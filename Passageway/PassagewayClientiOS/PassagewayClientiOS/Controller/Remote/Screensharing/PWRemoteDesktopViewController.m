//
//  PWRemoteDesktopViewController.m
//  PassagewayClientiOS
//
//  Created by Mark Sinkovics on 10/10/12.
//  Copyright (c) 2012 mscodefactory. All rights reserved.
//

#import <PWServer/PWMsgBase.h>

#import "PWRemoteDesktopViewController.h"
#import "PWRemoteDesktopView.h"
#import "PWTapNPanGestureRecognizer.h"

@implementation PWRemoteDesktopViewController

#pragma mark - View Handling Methods

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	[self setRemoteDesktopProperties];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	[self _addTapGesturesForClickRecognizing];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	
	[super resetGestures];
}

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods

- (void)_addTapGesturesForClickRecognizing
{
	//	Tap and drag Gesture
	
	PWTapNPanGestureRecognizer* tapNDragGesture =
		[[PWTapNPanGestureRecognizer alloc] initWithTarget:self action:@selector(_handleTapNDragGestureRecognizer:)];
	
	tapNDragGesture.numberOfTapsRequired = 2;
	
	[self.view addGestureRecognizer:tapNDragGesture];
	
	//	double pan Gesture
	
	PWTapNPanGestureRecognizer* tripleTapNDragGesture =
		[[PWTapNPanGestureRecognizer alloc] initWithTarget:self action:@selector(_handleTripleTapNDragGestureRecognizer:)];
	
	tripleTapNDragGesture.numberOfTapsRequired = 2;
	
	tripleTapNDragGesture.numberOfTouchesRequired = 2;
	
	[self.view addGestureRecognizer:tripleTapNDragGesture];

	// simple left gesture
	
	UITapGestureRecognizer* tapGestureSimpleLeft =
		[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_handleSimpleLeftTapGestureRecognizer:)];
	
	tapGestureSimpleLeft.numberOfTouchesRequired = 1;
	
	tapGestureSimpleLeft.numberOfTapsRequired = 1;
	
	[self.view addGestureRecognizer:tapGestureSimpleLeft];
	
	// double left gesture
	
	UITapGestureRecognizer* tapGestureDoubleLeft =
		[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_handleDoubleLeftTapGestureRecognizer:)];
	
	tapGestureDoubleLeft.numberOfTouchesRequired = 1;
	
	tapGestureDoubleLeft.numberOfTapsRequired = 2;
	
	[self.view addGestureRecognizer:tapGestureDoubleLeft];
	
	[tapGestureSimpleLeft requireGestureRecognizerToFail:tapGestureDoubleLeft];
	
	// simple right gesture	
	
	UITapGestureRecognizer* tapGestureSimpleRight =
		[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_handleSimpleRightTapGestureRecognizer:)];
	
	tapGestureSimpleRight.numberOfTouchesRequired = 2;
	
	tapGestureSimpleRight.numberOfTapsRequired = 1;
	
	[self.view addGestureRecognizer:tapGestureSimpleRight];
	
	// Requirements
	
	[tapGestureSimpleLeft requireGestureRecognizerToFail:tapGestureDoubleLeft];
	
	[tapNDragGesture requireGestureRecognizerToFail:tapGestureDoubleLeft];
	
	[tapGestureSimpleLeft requireGestureRecognizerToFail:tapNDragGesture];
		
	[tapGestureSimpleRight requireGestureRecognizerToFail:tripleTapNDragGesture];
}

- (void)_handleSimpleLeftTapGestureRecognizer:(UITapGestureRecognizer*)tapGesture
{
	CGFloat scale = (1.0 / self.screenSharingResponse.scale.floatValue);
	
	CGPoint point = [tapGesture locationInView:_remoteDesktopView];
	
	[self handleMouseLeftClick:1 atX:(point.x * scale) y:(point.y * scale)];
}

- (void)_handleDoubleLeftTapGestureRecognizer:(UITapGestureRecognizer*)tapGesture
{
	CGFloat scale = (1.0 / self.screenSharingResponse.scale.floatValue);
	
	CGPoint point = [tapGesture locationInView:_remoteDesktopView];
	
	[self handleMouseLeftClick:2 atX:(point.x * scale) y:(point.y * scale)];
}

- (void)_handleSimpleRightTapGestureRecognizer:(UITapGestureRecognizer*)tapGesture
{
	CGFloat scale = (1.0 / self.screenSharingResponse.scale.floatValue);
	
	CGPoint point = [tapGesture locationInView:_remoteDesktopView];
	
	[self handleMouseRightClick:1 atX:(point.x * scale) y:(point.y * scale)];
}

- (void)_handleTapNDragGestureRecognizer:(PWTapNPanGestureRecognizer*)gesture
{
	CGFloat scale = (1.0 / self.screenSharingResponse.scale.floatValue);
	
	CGPoint point = [gesture locationInView:_remoteDesktopView];
	
	switch (gesture.state)
	{
		case UIGestureRecognizerStateBegan:
		{			
			[self handleMouseDragAtX:0.0 y:0.0];
			
			_remoteDesktopScrollView.scrollEnabled = NO;
		}
			break;
		case UIGestureRecognizerStateChanged:
		{
			[self handleMouseDragPositionAtX:(point.x * scale)
										   y:(point.y * scale)];
		}
			break;
		case UIGestureRecognizerStateEnded:
		case UIGestureRecognizerStateCancelled:
		case UIGestureRecognizerStateFailed:
		{
			[self handleMouseDragDropAtX:0.0 y:0.0];
			
			_remoteDesktopScrollView.scrollEnabled = YES;
		}
			break;
		default:
			break;
	}
}

- (void)_handleTripleTapNDragGestureRecognizer:(PWTapNPanGestureRecognizer*)gesture
{
	CGPoint location = [gesture locationInView:self.view];
	
	switch (gesture.state)
	{
		case UIGestureRecognizerStateBegan:
		{
			_previouslocation.x = location.x;
			
			_previouslocation.y = location.y;
			
			_remoteDesktopScrollView.scrollEnabled = NO;
		}
			break;
		case UIGestureRecognizerStateChanged:
		{
			[self handleMouseScrollAtX:(location.y - _previouslocation.y) * 10.0
									 y:(location.x - _previouslocation.x) * 10.0];
			
			_previouslocation = location;
		}
			break;
		case UIGestureRecognizerStateEnded:
		case UIGestureRecognizerStateCancelled:
		case UIGestureRecognizerStateFailed:
		{
			_remoteDesktopScrollView.scrollEnabled = YES;
		}
			break;
		default:
			break;
	}
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
	return _remoteDesktopView;	
}

- (void)setRemoteDesktopProperties
{
	CGSize desktopSize = CGSizeMake(self.screenSharingResponse.numV.intValue * self.screenSharingResponse.sizeH.floatValue,
									self.screenSharingResponse.numH.intValue * self.screenSharingResponse.sizeV.floatValue);
	
	_remoteDesktopView.frame = CGRectMake(0.0, 0.0, desktopSize.width, desktopSize.height);
	
	_remoteDesktopScrollView.contentSize = desktopSize;
	
	CGFloat minZoom = (CGRectGetWidth(self.view.bounds) / _remoteDesktopScrollView.contentSize.width);
	
    _remoteDesktopScrollView.minimumZoomScale = minZoom;
	
    _remoteDesktopScrollView.maximumZoomScale = 4.0;
	
	[_remoteDesktopView setNumberOfImagesVertically:self.screenSharingResponse.numV.intValue horizontally:self.screenSharingResponse.numH.intValue];
	
	[_remoteDesktopView setImageSizeWidth:self.screenSharingResponse.sizeH.floatValue height:self.screenSharingResponse.sizeV.floatValue];
}

#pragma mark - PWRemoteControlClientManagerDelegate Methods

- (void)manager:(PWRemoteControlClientManager*)manager didReceiveScreenSharingData:(NSData *)data
{
	@autoreleasepool
	{
		NSMutableData* resultData = [NSMutableData dataWithData:data];
		
		PWUDPImageHeader _imageHeader;
		
		[resultData getBytes:&_imageHeader range:NSMakeRange(0, sizeof(PWUDPImageHeader))];
		
		[resultData replaceBytesInRange:NSMakeRange(0, sizeof(PWUDPImageHeader)) withBytes:NULL length:0];
		
		CFMutableDataRef imgData = (__bridge_retained CFMutableDataRef)resultData;
		
		CGDataProviderRef imgDataProvider = CGDataProviderCreateWithCFData (imgData);
		
		CGImageRef image = CGImageCreateWithJPEGDataProvider(imgDataProvider, NULL, true, kCGRenderingIntentDefault);
		
		CFRelease(imgDataProvider);
		
		CFRelease(imgData);
		
		[_remoteDesktopView updateWithImageRef:image atIndex:_imageHeader.index];
		
		[_remoteDesktopView setNeedsDisplay];
	}
}

@end
