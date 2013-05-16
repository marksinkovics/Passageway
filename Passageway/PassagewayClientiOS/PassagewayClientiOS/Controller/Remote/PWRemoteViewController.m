//
//  PWRemoteViewController.m
//  PassagewayClientiOS
//
//  Created by Mark Sinkovics on 10/10/12.
//  Copyright (c) 2012 mscodefactory. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "PWRemoteViewController.h"
#import "PWStatInfoView.h"
#import "PWStateBarButtonItem.h"

@interface PWRemoteViewController ()

@end

@implementation PWRemoteViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	__flag.isKeyboardHidden = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
		
	[_statInfoView start];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
	
	[_statInfoView stop];
}

#pragma mark - Memory Management

- (void)dealloc
{
	[_schedulerTimer invalidate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Overrided Methods

/*
- (UIView*)inputAccessoryView
{
	if (_functionKeysToolbar == nil)
	{
		_functionKeysToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 50.0)];
		
		PWStateBarButtonItem* commandItem = [[PWStateBarButtonItem alloc] initWithTitle:@"⌘"
																				  style:UIBarButtonItemStyleBordered
																				 target:self
																				 action:@selector(_toolbarAction:)];
		
		PWStateBarButtonItem* controlItem = [[PWStateBarButtonItem alloc] initWithTitle:@"ctrl"
																		style:UIBarButtonItemStyleBordered
																	   target:self
																	   action:nil];
		
		PWStateBarButtonItem* shiftItem = [[PWStateBarButtonItem alloc] initWithTitle:@"⇧"
																	  style:UIBarButtonItemStyleBordered
																	 target:self
																	 action:nil];
		
		PWStateBarButtonItem* altItem = [[PWStateBarButtonItem alloc] initWithTitle:@"⌥"
																	style:UIBarButtonItemStyleBordered
																   target:self
																   action:nil];
		
		_functionKeysToolbar.items = @[commandItem, controlItem, shiftItem, altItem];
		
	}
	
	return _functionKeysToolbar;
}
*/

#pragma mark - Public Methods

- (void)navigationBarDidHide:(BOOL)hidden
{
	
}

- (void)resetGestures
{
	for (UIGestureRecognizer* gesture in self.view.gestureRecognizers)
	{
		[self.view removeGestureRecognizer:gesture];
	}
	
	[self _addNavigationBarHideGesture];
}

#pragma mark - Private Methods

- (void)_toolbarAction:(id)item
{	
	
}

- (void)_addNavigationBarHideGesture
{
	UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
	
	tapGesture.numberOfTouchesRequired = 3;
	
	tapGesture.numberOfTapsRequired = 2;
	
	[self.view addGestureRecognizer:tapGesture];

}

- (void)handleTapGesture:(UIGestureRecognizer*)sender
{
	[[UIApplication sharedApplication] setStatusBarHidden:!__flag.isNavigationBarHidden
											withAnimation:UIStatusBarAnimationSlide];
	
	[self.navigationController setNavigationBarHidden:!__flag.isNavigationBarHidden
											 animated:YES];
	
	__flag.isNavigationBarHidden = !__flag.isNavigationBarHidden;
	
	[self navigationBarDidHide:__flag.isNavigationBarHidden];
}

- (void)_setKeyboardHidden:(BOOL)hidden
{
	if (hidden)
	{
		[self resignFirstResponder];
	}
	else
	{
		[self becomeFirstResponder];
	}
	
	__flag.isKeyboardHidden = hidden;
}

#pragma mark - User Action Methods

- (IBAction)stop:(id)sender
{
	[self.clientManager enableScreenSharing:NO remoteDevice:NO];
	
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)openKeyboard:(id)sender
{
	[self _setKeyboardHidden:!__flag.isKeyboardHidden];
}

#pragma mark - UIKeyInput Methods

- (BOOL)hasText
{
	return YES;
}

- (void)insertText:(NSString *)text
{
	const char* str = [text UTF8String];
	
	if (str[0] == 10)
	{
		[self handleKeyboardPressCharacters:@"RETURN"];
	}
	else
	{
		[self handleKeyboardPressCharacters:text];
	}
}

- (void)deleteBackward
{
	[self handleKeyboardPressCharacters:@"DEL"];
}

- (BOOL)canBecomeFirstResponder
{
	return YES;
}

- (BOOL)canResignFirstResponder
{
	return YES;
}

- (BOOL)isFirstResponder
{
	return YES;
}

- (void)willShowUIKeyboard:(NSNotification*)noticatio
{
	
}

#pragma mark - PWRemoteControlClientManagerDelegate Methods

- (NSData*)remoteDeviceDataForDeviceType:(PWCommunicationRemoteDeviceType)deviceType toManager:(PWRemoteControlClientManager *)manager
{
	NSData* data = nil;
	
	switch (deviceType)
	{
		case PWCommunicationRemoteDeviceTypeMouse:
		{
			data = [NSData dataWithBytes:&_mouseData length:sizeof(PWMouseData)];
		}
			break;
		case PWCommunicationRemoteDeviceTypeKeyboard:
		{
			data = [NSData dataWithBytes:&_keyboardData length:sizeof(PWKeyboardData)];
		}
			break;
	}
	
	return data;
}

#pragma mark - Input Device Methods

- (void)handleMouseLeftClick:(NSInteger)click atX:(float)x y:(float)y
{
	switch (click)
	{
		case 1:
		{
			_mouseData.type = PWMouseDataTypeLeftClick;
			_mouseData.dx	= x;
			_mouseData.dy	= y;
			[self.clientManager sendMouseData];
		}
			break;
		case 2:
		{
			_mouseData.type = PWMouseDataTypeLeftDoubleClick;
			_mouseData.dx	= x;
			_mouseData.dy	= y;
			[self.clientManager sendMouseData];
		}
			break;
	}
}

- (void)handleMouseRightClick:(NSInteger)click atX:(float)x y:(float)y
{
	switch (click)
	{
		case 1:
		{
			_mouseData.type = PWMouseDataTypeRightClick;
			_mouseData.dx	= x;
			_mouseData.dy	= y;
			[self.clientManager sendMouseData];
		}
			break;
		case 2:
		{
			
		}
			break;
		default:
			break;
	}}

- (void)handleMouseDragAtX:(float)x y:(float)y
{
	_mouseData.type = PWMouseDataTypeDrag;
	
	_mouseData.dx = x;
	
	_mouseData.dy = y;
	
	[self.clientManager sendMouseData];
}

- (void)handleMouseDragDeltaAtX:(float)x y:(float)y
{
	_mouseData.type = PWMouseDataTypeDragDelta;
	
	_mouseData.dx = x;
	
	_mouseData.dy = y;
	
	[self.clientManager sendMouseData];
}

- (void)handleMouseDragPositionAtX:(float)x y:(float)y
{
	_mouseData.type = PWMouseDataTypeDragPosition;
	
	_mouseData.dx = x;
	
	_mouseData.dy = y;
	
	[self.clientManager sendMouseData];
}

- (void)handleMouseDragDropAtX:(float)x y:(float)y
{
	_mouseData.type = PWMouseDataTypeDragDrop;
	
	_mouseData.dx = x;
	
	_mouseData.dy = y;
	
	[self.clientManager sendMouseData];
}

- (void)handleMouseDeltaAtX:(float)x y:(float)y
{
	_mouseData.type = PWMouseDataTypeDelta;
	
	_mouseData.dx = x;
	
	_mouseData.dy = y;
	
	[self.clientManager sendMouseData];
}

- (void)handleMouseScrollAtX:(float)x y:(float)y
{
	_mouseData.type = PWMouseDataTypeScroll;
	
	_mouseData.dx = x;
	
	_mouseData.dy = y;
	
	[self.clientManager sendMouseData];
}


- (void)handleKeyboardPressCharacters:(NSString*)characters
{
	const char *  _str = [characters UTF8String];
	
	if (characters.length > 6)
	{
		memcpy ( _keyboardData.str, _str, 7 );
	}
	else
	{
		memcpy ( _keyboardData.str, _str, strlen(_str) + 1 );
	}
	
	_keyboardData.functionKeys = 0;
	
	[self.clientManager sendKeyboardData];
}

@end
