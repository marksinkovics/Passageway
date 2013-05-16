//
//  PWTapNPanGestureRecognizer.m
//  PassagewayClientiOS
//
//  Created by Mark Sinkovics on 4/22/13.
//  Copyright (c) 2013 Mark Sinkovics. All rights reserved.
//

#import "PWTapNPanGestureRecognizer.h"

@implementation PWTapNPanGestureRecognizer

- (id)initWithTarget:(id)target action:(SEL)action
{
    self = [super initWithTarget:target action:action];
	
    if (self)
	{
        self.numberOfTouchesRequired = 1;
		
		self.numberOfTapsRequired = 1;
    }
    return self;
}

- (void)reset
{
	[super reset];
	
	__flag.touchesCount = 0;
	
	if (_timer)
	{
		[_timer invalidate], _timer = nil;
	}
}

#pragma mark - Private Methods

- (void)timerAction:(NSTimer*)timer
{
	__flag.touchesCount = 0;
	
	self.state = UIGestureRecognizerStateFailed;
	
	if (_timer)
	{
		[_timer invalidate], _timer = nil;
	}
}

#pragma mark - Touch Handle Methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesBegan:touches withEvent:event];
	
	if (touches.count == self.numberOfTouchesRequired)
	{
		if (self.state == UIGestureRecognizerStatePossible || self.state == UIGestureRecognizerStateEnded)
		{
			__flag.touchesCount++;
			
			if (__flag.touchesCount == self.numberOfTapsRequired)
			{
				if (_timer)
				{
					[_timer invalidate], _timer = nil;
					
					self.state = UIGestureRecognizerStateBegan;
				}
			}
		}
	}
	else
	{
		self.state = UIGestureRecognizerStateFailed;
	}
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesMoved:touches withEvent:event];
	
	if ((self.state == UIGestureRecognizerStateBegan
		|| self.state == UIGestureRecognizerStateChanged)
		&& __flag.touchesCount == self.numberOfTapsRequired)
	{
		self.state = UIGestureRecognizerStateChanged;
	}
	else
	{
		self.state = UIGestureRecognizerStateFailed;
	}
	
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesEnded:touches withEvent:event];
	
	if (self.state == UIGestureRecognizerStateChanged && __flag.touchesCount == self.numberOfTapsRequired)
	{
		__flag.touchesCount = 0;

        self.state = UIGestureRecognizerStateRecognized;
    }
	else if (__flag.touchesCount < self.numberOfTapsRequired)
	{
		_timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timerAction:) userInfo:nil repeats:NO];
	}
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesCancelled:touches withEvent:event];
	
	__flag.touchesCount = 0;
	
	if (_timer)
	{
		[_timer invalidate], _timer = nil;
	}

	self.state = UIGestureRecognizerStateCancelled;
}

@end
