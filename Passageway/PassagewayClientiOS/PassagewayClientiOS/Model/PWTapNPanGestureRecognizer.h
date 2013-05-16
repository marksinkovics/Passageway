//
//  PWTapNPanGestureRecognizer.h
//  PassagewayClientiOS
//
//  Created by Mark Sinkovics on 4/22/13.
//  Copyright (c) 2013 Mark Sinkovics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIGestureRecognizerSubclass.h>

@interface PWTapNPanGestureRecognizer : UIGestureRecognizer
{
	NSTimer* _timer;
	
	struct {
		unsigned int touchesCount;
	} __flag;
}

/*!
 @property numberOfTapsRequired
 Default value is 1.
 */
@property (nonatomic, assign) NSUInteger numberOfTapsRequired;

/*!
 @property numberOfTouchesRequired
 Default value is 1.
 */
@property (nonatomic, assign) NSUInteger numberOfTouchesRequired;

@end
