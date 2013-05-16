//
//  PWLogic.h
//  PassagewayClientiOS
//
//  Created by Mark Sinkovics on 4/16/13.
//  Copyright (c) 2013 mscodefactory. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>

@interface PWLogic : NSObject
{
	CMMotionManager *_motionManager;
}

@property (strong, nonatomic, readonly) CMMotionManager *motionManager;

#pragma mark - Class Methods

+ (PWLogic*)sharedManager;

#pragma mark - Instance Methods

- (CMMotionManager *)motionManager;

@end
