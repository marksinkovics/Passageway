//
//  PWStateBarButtonItem.m
//  PassagewayClientiOS
//
//  Created by Mark Sinkovics on 5/8/13.
//  Copyright (c) 2013 mscodefactory. All rights reserved.
//

#import "PWStateBarButtonItem.h"


@implementation PWStateBarButtonItem

- (void)setTarget:(id)target
{
	[super setTarget:self];
	
	_realTarget = target;
}

- (void)setAction:(SEL)action
{
	[super setAction:@selector(_changeStateAction:)];
	
	_realAction = action;
}

#pragma mark - Private Methods

- (void)_changeStateAction:(id)sender
{
	_selected = !_selected;
	
	if (_selected)
	{
		self.tintColor = [UIColor colorWithRed:0.604 green:0.714 blue:0.896 alpha:1.000];
	}
	else
	{
		self.tintColor = nil;
	}
	
	[self _callRealActionWithSender:sender];
	
}

- (void)_callRealActionWithSender:(id)sender
{
	if (_realTarget && _realAction)
	{
		if ([_realTarget respondsToSelector:_realAction])
		{
			[_realTarget performSelector:_realAction withObject:sender afterDelay:0];
		}
	}
}

@end
