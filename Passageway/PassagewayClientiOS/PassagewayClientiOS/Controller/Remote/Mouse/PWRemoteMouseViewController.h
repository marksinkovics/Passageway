//
//  PWRemoteMouseViewController.h
//	PassagewayClientiOS
//
//  Created by Mark Sinkovics on 4/5/13.
//  Copyright (c) 2013 mscodefactory. All rights reserved.
//

#import "PWRemoteViewController.h"

typedef enum _PWMouseType
{
	PWMouseTypeGyro		= 0,
	PWMouseTypeTouchPad = 1,
	
} PWMouseType;

@interface PWRemoteMouseViewController : PWRemoteViewController
{
	PWMouseType _mouseType;
		
	__weak IBOutlet UISegmentedControl *_mouseTypeSwitcher;
	
	UITapGestureRecognizer *_navigationBarDismisserGesture;
	
	struct {
		unsigned int gyroActive:1;
	} __flag_mouse;
}

- (IBAction)mouseTypeSwitcherAction:(UISegmentedControl*)sender;

@end
