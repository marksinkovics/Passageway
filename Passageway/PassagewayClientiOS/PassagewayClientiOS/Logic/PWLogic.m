//
//  PWLogic.m
//  PassagewayClientiOS
//
//  Created by Mark Sinkovics on 4/16/13.
//  Copyright (c) 2013 mscodefactory. All rights reserved.
//

#import "PWLogic.h"

@implementation PWLogic

#pragma mark Singleton Methods

+ (PWLogic*)sharedManager
{
    static PWLogic *sharedLogicManager = nil;
	
    static dispatch_once_t onceToken;
	
    dispatch_once(&onceToken, ^{
		
        sharedLogicManager = [[self alloc] init];
		
    });
	
    return sharedLogicManager;
}

- (id)init
{
	if (self = [super init])
	{
		
	}
	return self;
}

- (void)dealloc
{
	// Should never be called, but just here for clarity really.
}

#pragma mark - Setter Methods

- (CMMotionManager *)motionManager
{
    static dispatch_once_t onceToken;
	
    dispatch_once(&onceToken, ^{
		
        _motionManager = [[CMMotionManager alloc] init];
		
    });
	
    return _motionManager;
}



@end
