//
//  PWMainController.m
//  PassagewayServerMac
//
//  Created by Mark Sinkovics on 4/14/13.
//
//

#import <SystemConfiguration/SystemConfiguration.h>

#import "PWMainController.h"
#import "PWImageMacLib.h"
#import "PWMouseMacLib.h"
#import "PWKeyboardMacLib.h"
#import "PWDisplayMacLib.h"

@implementation PWMainController

- (id)init
{
    self = [super init];
	
    if (self)
	{
		_serverManager = [[PWRemoteControlServerManager alloc] init];
		
		_serverManager.delegate = self;
		
		_serverManager.imageScale = 0.5;
		
		_sizeImageContainer = -1;
		
		_imageContainer = NULL;
		
		_private_queue = dispatch_queue_create("com.mscodefactory.maincontroller.task", NULL);
        
        NSString* _computerName = [self _getComputerName];
        
        [_serverManager changeBonjourName:_computerName];
    }
    return self;
}

#pragma mark - Memory Management

- (void)dealloc
{
	[_serverManager stop];
    
    [_serverManager release], _serverManager = nil;
    
    [self _freeImageContainer];
	
	[self _freeOldCGImages];
	
	dispatch_release(_private_queue);
    
    [super dealloc];
}

#pragma mark - Public Methods

- (void)startStop
{
	NSLog(@"%s", __PRETTY_FUNCTION__);
	
	if ([_serverManager active])
	{
		[_serverManager stop];
	}
	else
	{
		[_serverManager start];

	}
}

- (BOOL)isActive
{
	return [_serverManager active];
}

#pragma mark - Private Methods

- (NSString*)_getComputerName
{
	CFStringRef name = SCDynamicStoreCopyComputerName(NULL,NULL);
    
	NSString* computerName=[NSString stringWithString:(NSString *)name];
    
	CFRelease(name);
    
	return computerName;
}

- (void)_freeOldCGImages
{
	if (_oldCGImages != NULL)
	{
		for (int i = 0; i < _sizeImageContainer; i++)
		{
			CGImageRef img = _oldCGImages[i];
			
			CFRelease(img);
		}
		
		free(_oldCGImages);
	}
}

- (void)_freeImageContainer
{
    if (_imageContainer != NULL && _sizeImageContainer != -1)
	{
		for (int i = 0; i < _sizeImageContainer; i++)
		{
			NSData* imageData = _imageContainer[i];
			
			[imageData release];
		}
		
		free(_imageContainer);
	}
}

- (void)doScreenSharing:(id)sender
{
	NSLog(@"%s", __PRETTY_FUNCTION__);
	
	//	dispatch_sync(_private_queue, ^{
	
	[self _freeImageContainer];
	
	//		_imageContainer = imageSliceDatasFromFullScreenWithComparing(_serverManager.imageScale, &_sizeImageContainer, &_oldCGImages);
	
	_imageContainer = imageSliceDatasFromFullScreen(_serverManager.imageScale, &_sizeImageContainer);
	
	[_serverManager sendSreenImage];
	
	//	});
	
}

- (void)_handleMouseData:(NSData*)mouseData
{
	PWMouseData _mouseData;
	
	[mouseData getBytes:&_mouseData length:sizeof(PWMouseData)];
	
	switch (_mouseData.type)
	{
		case PWMouseDataTypeLeftClick:
		{
			if (_mouseData.dx != MAXFLOAT && _mouseData.dy != MAXFLOAT)
			{
				mouseMove(_mouseData.dx, _mouseData.dy);
			}
			
			mouseLeftClick(0, 1);
		}
			break;
		case PWMouseDataTypeLeftDoubleClick:
		{
			if (_mouseData.dx != MAXFLOAT && _mouseData.dy != MAXFLOAT)
			{
				mouseMove(_mouseData.dx, _mouseData.dy);
			}
			
			mouseLeftClick(0, 2);
		}
			break;
		case PWMouseDataTypeRightClick:
		{
			if (_mouseData.dx != MAXFLOAT && _mouseData.dy != MAXFLOAT)
			{
				mouseMove(_mouseData.dx, _mouseData.dy);
			}
			
			mouseLeftClick(1, 1);
		}
			break;
		case PWMouseDataTypeDelta:
		{
			mouseAhead(_mouseData.dx, _mouseData.dy);
		}
			break;
		case PWMouseDataTypeDrag:
		{
			mouseDrag();
		}
			break;
		case PWMouseDataTypeDragDelta:
		{
			mouseDragAhead(_mouseData.dx, _mouseData.dy);
		}
			break;
		case PWMouseDataTypeDragPosition:
		{
			mouseDragMove(_mouseData.dx, _mouseData.dy);
		}
			break;
		case PWMouseDataTypeDragDrop:
		{
			mouseDragDrop();
		}
			break;
		case PWMouseDataTypeScroll:
		{
			mouseScrollWheel(_mouseData.dx, _mouseData.dy);
		}
			break;
	}
	
//	NSLog(@"mode: %d, %f, %f", _mouseData.type, _mouseData.dx, _mouseData.dy);
}

- (void)_handleKeyboardData:(NSData*)keyboardData
{
	PWKeyboardData _keyboardData;
	
	[keyboardData getBytes:&_keyboardData length:sizeof(PWKeyboardData)];
	
	int success = false;
			
	PWKeyCode keyCode = GetKeyCodeFromStr(_keyboardData.str, &success);
	
	if (success)
	{
		PressKeyCode(keyCode);
	}
//	
//	NSLog(@"chars %@", [[[NSString alloc] initWithCString:_keyboardData.str encoding:NSUTF8StringEncoding] autorelease]);
}

#pragma mark - PWRemoteControlServerManagerDelegate Methods

- (void)manager:(PWRemoteControlServerManager *)manager numTileHotizontal:(int *)horizontal numTileVertical:(int *)vertical tileWidth:(float *)width tileHeight:(float *)height
{
	getNumberOfTileByFullScreen(_serverManager.imageScale, horizontal, vertical, width, height);
}

- (BOOL)shouldScreenSharingForManager:(PWRemoteControlServerManager*)manager
{
	return YES;
}

- (void)startScreenSharingForManager:(PWRemoteControlServerManager*)manager
{
	NSLog(@"%s", __PRETTY_FUNCTION__);
	
	ActivateDisplay(1);
	
	_scheduler = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(doScreenSharing:) userInfo:nil repeats:YES];
	
	[_scheduler retain];
}

- (void)stopScreenSharingForManager:(PWRemoteControlServerManager*)manager
{
	NSLog(@"%s", __PRETTY_FUNCTION__);
	
	[_scheduler invalidate];
	
	[_scheduler release], _scheduler = nil;
}

- (NSInteger)numberOfDataForScreenSharingForManager:(PWRemoteControlServerManager*)manager
{
	//	NSLog(@"_sizeImageContainer %d", _sizeImageContainer);
	
	return _sizeImageContainer;
}

- (NSData*)manager:(PWRemoteControlServerManager*)manager dataForScreenSharingAtIndex:(NSInteger)index
{
	if (_imageContainer[index] != NULL)
	{
		return _imageContainer[index];
	}
	else
	{
		return nil;
	}
}

- (BOOL)manager:(PWRemoteControlServerManager*)manager validateUsername:(NSString*)username withPassword:(NSString*)password
{
	return ([username isEqualToString:@"test"] && [password isEqualToString:@"test"]);
}

- (BOOL)shouldRemoteDeviceForManager:(PWRemoteControlServerManager*)manager
{
	return YES;
}


- (void)manager:(PWRemoteControlServerManager *)manager didReceiveRemoteDeviceData:(NSData *)data byRemoteDeviceType:(PWCommunicationRemoteDeviceType)deviceType
{
	switch (deviceType)
	{
		case PWCommunicationRemoteDeviceTypeMouse:
		{
			[self _handleMouseData:data];
		}
			break;
		case PWCommunicationRemoteDeviceTypeKeyboard:
		{
			[self _handleKeyboardData:data];
		}
			break;
		default:
			break;
	}
}


@end
