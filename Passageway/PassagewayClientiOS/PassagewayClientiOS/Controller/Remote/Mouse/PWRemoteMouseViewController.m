//
//  PWRemoteMouseViewController.m
//  PassagewayClientiOS
//
//  Created by Mark Sinkovics on 4/5/13.
//  Copyright (c) 2013 mscodefactory. All rights reserved.
//

#import <CoreMotion/CoreMotion.h>

#import "PWRemoteMouseViewController.h"
#import "PWTapNPanGestureRecognizer.h"
#import "PWLogic.h"

@interface PWRemoteMouseViewController ()

@end

@implementation PWRemoteMouseViewController

static const NSTimeInterval gyroUpdateInterval = 0.02;

#pragma mark - View handling Methods

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	[_mouseTypeSwitcher setSelectedSegmentIndex:1];
	
	[self _changeMouseType:_mouseTypeSwitcher.selectedSegmentIndex];
}

#pragma mark - User Action Methods

- (IBAction)mouseTypeSwitcherAction:(UISegmentedControl*)sender
{
	[self _changeMouseType:sender.selectedSegmentIndex];
}

#pragma mark - Private Methods

- (void)_changeMouseType:(PWMouseType)mouseType
{
	[self resetGestures];
	
	switch (mouseType)
	{
		case PWMouseTypeGyro:
		{
			[self _addGestureForButtonActionRecognizing];
			
			[self _changeGyroEnable:YES];
		}
			break;
			
		case PWMouseTypeTouchPad:
		{
			[self _addGestureRecognizers];
			
			[self _changeGyroEnable:NO];
		}
			break;
		default:
			break;
	}
	
	_mouseType = mouseType;
}

- (void)_addGestureForButtonActionRecognizing
{
	UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_handleNButtonActionRecognizingTapGesture:)];
	
	tapGesture.numberOfTouchesRequired = 1;
	
	tapGesture.numberOfTapsRequired = 1;
	
	[self.view addGestureRecognizer:tapGesture];
}

- (void)_addGestureRecognizers
{

	//	Tap and drag Gesture

	PWTapNPanGestureRecognizer* tapNDragGesture =
		[[PWTapNPanGestureRecognizer alloc] initWithTarget:self action:@selector(_handleTapNDragGestureRecognizer:)];
	
	tapNDragGesture.numberOfTapsRequired = 2;
	
	[self.view addGestureRecognizer:tapNDragGesture];
	
	//	single pan Gesture
	
	UIPanGestureRecognizer* panGesture =
		[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(_handlePanGestureRecognizer:)];
	
	panGesture.minimumNumberOfTouches = 1;
	
	panGesture.maximumNumberOfTouches = 1;
	
	[self.view addGestureRecognizer:panGesture];
	
	//	double pan Gesture
	
	UIPanGestureRecognizer* doublePanGesture =
		[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(_handleDoublePanGestureRecognizer:)];
	
	doublePanGesture.minimumNumberOfTouches = 2;
	
	doublePanGesture.maximumNumberOfTouches = 2;
	
	[self.view addGestureRecognizer:doublePanGesture];
	
	//	single tap gesture
	
	UITapGestureRecognizer* tapGestureSimpleLeft =
		[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_handleSimpleLeftTapGestureRecognizer:)];
	
	tapGestureSimpleLeft.numberOfTouchesRequired = 1;
	
	tapGestureSimpleLeft.numberOfTapsRequired = 1;
	
	[self.view addGestureRecognizer:tapGestureSimpleLeft];

	//	double tap gesture
	
	UITapGestureRecognizer* tapGestureDoubleLeft =
		[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_handleDoubleLeftTapGestureRecognizer:)];
	
	tapGestureDoubleLeft.numberOfTouchesRequired = 1;
	
	tapGestureDoubleLeft.numberOfTapsRequired = 2;
	
	[self.view addGestureRecognizer:tapGestureDoubleLeft];
	
	//	two fingers single tap gesture
	
	UITapGestureRecognizer* tapGestureSimpleRight =
		[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_handleSimpleRightTapGestureRecognizer:)];
	
	tapGestureSimpleRight.numberOfTouchesRequired = 2;
	
	tapGestureSimpleRight.numberOfTapsRequired = 1;
	
	[self.view addGestureRecognizer:tapGestureSimpleRight];
	
	// Requirements
	
	[tapGestureSimpleLeft requireGestureRecognizerToFail:tapGestureDoubleLeft];
		
	[tapNDragGesture requireGestureRecognizerToFail:tapGestureDoubleLeft];
	
	[tapGestureSimpleLeft requireGestureRecognizerToFail:tapNDragGesture];
	
	[panGesture requireGestureRecognizerToFail:tapNDragGesture];
	
	[doublePanGesture requireGestureRecognizerToFail:panGesture];
}

- (void)_changeGyroEnable:(BOOL)enable
{
	if (enable && !__flag_mouse.gyroActive)
	{
		CMMotionManager *mManager = [[PWLogic sharedManager] motionManager];
		
		PWRemoteMouseViewController * __weak weakSelf = self;
		
		if ([mManager isGyroAvailable] == YES)
		{
			[mManager setGyroUpdateInterval:gyroUpdateInterval];
			
			[mManager startGyroUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMGyroData *gyroData, NSError *error) {
				
				[weakSelf _changeGyroRotationRate:gyroData.rotationRate];
				
			}];
		}
		
		__flag_mouse.gyroActive = YES;
	}
	else if(!enable && __flag_mouse.gyroActive)
	{
		CMMotionManager *mManager = [[PWLogic sharedManager] motionManager];
		
		if ([mManager isGyroActive] == YES)
		{
			[mManager stopGyroUpdates];
		}
		
		__flag_mouse.gyroActive = NO;
	}
}

- (void)_changeGyroRotationRate:(CMRotationRate)gyroRotationRate
{
	static double gyroMinChangingValue = 1.0;

	BOOL _needToSend = NO;
	
	_needToSend =	((gyroRotationRate.x >= gyroMinChangingValue)
					 || (gyroRotationRate.x <= -gyroMinChangingValue)
					 || (gyroRotationRate.z >= gyroMinChangingValue)
					 || (gyroRotationRate.z <= -gyroMinChangingValue));

	if (_needToSend)
	{
		[self handleMouseDeltaAtX:(gyroRotationRate.z * -10.0) y:(gyroRotationRate.x * -10.0)];
	}
}

#pragma mark - UIGestureRecognizers Delegate Methods

- (void)_handleNButtonActionRecognizingTapGesture:(UITapGestureRecognizer*)tapGesture
{
	CGPoint location = [tapGesture locationInView:self.view];
	
	CGFloat middleX = (CGRectGetWidth(self.view.frame) / 2.0);
	
	if (location.x < middleX)
	{
		[self handleMouseLeftClick:1 atX:MAXFLOAT y:MAXFLOAT];
	}
	else if (location.x > middleX)
	{
		[self handleMouseRightClick:1 atX:MAXFLOAT y:MAXFLOAT];
	}
}

- (void)_handlePanGestureRecognizer:(UIPanGestureRecognizer*)panGesture
{
	CGPoint location = [panGesture locationInView:self.view];

	switch (panGesture.state)
	{
		case UIGestureRecognizerStateBegan:
		{
			_previouslocation.x = location.x;
			
			_previouslocation.y = location.y;
		}
			break;
		case UIGestureRecognizerStateChanged:
		{
			[self handleMouseDragDeltaAtX:(location.x - _previouslocation.x)
										y:(location.y - _previouslocation.y)];
			
			_previouslocation = location;
		}
			break;
		case UIGestureRecognizerStateEnded:
		case UIGestureRecognizerStateCancelled:
		case UIGestureRecognizerStateFailed:
		{

		}
			break;
		default:
			break;
	}
}

- (void)_handleDoublePanGestureRecognizer:(UIPanGestureRecognizer*)panGesture
{
	CGPoint location = [panGesture locationInView:self.view];
	
	switch (panGesture.state)
	{
		case UIGestureRecognizerStateBegan:
		{
			_previouslocation.x = location.x;
			
			_previouslocation.y = location.y;
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
			
		}
			break;
		default:
			break;
	}
}

- (void)_handleTapNDragGestureRecognizer:(UIPanGestureRecognizer*)panGesture
{
	CGPoint location = [panGesture locationInView:self.view];
	
	switch (panGesture.state)
	{
		case UIGestureRecognizerStateBegan:
		{
			_previouslocation.x = location.x;
			
			_previouslocation.y = location.y;
			
			[self handleMouseDragAtX:0.0 y:0.0];
		}
			break;
		case UIGestureRecognizerStateChanged:
		{
			[self handleMouseDragDeltaAtX:(location.x - _previouslocation.x)
										y:(location.y - _previouslocation.y)];
			
			_previouslocation = location;
		}
			break;
		case UIGestureRecognizerStateEnded:
		case UIGestureRecognizerStateCancelled:
		case UIGestureRecognizerStateFailed:
		{
			[self handleMouseDragDropAtX:0.0 y:0.0];
		}
			break;
		default:
			break;
	}
}

- (void)_handleSimpleLeftTapGestureRecognizer:(UITapGestureRecognizer*)tapGesture
{
	[self handleMouseLeftClick:1 atX:MAXFLOAT y:MAXFLOAT];
}

- (void)_handleDoubleLeftTapGestureRecognizer:(UITapGestureRecognizer*)tapGesture
{
	[self handleMouseLeftClick:2 atX:MAXFLOAT y:MAXFLOAT];
}

- (void)_handleSimpleRightTapGestureRecognizer:(UITapGestureRecognizer*)tapGesture
{
	[self handleMouseRightClick:1 atX:MAXFLOAT y:MAXFLOAT];
}

@end
