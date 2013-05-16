//
//  PWMsgControlRequest.m
//  PassagewayServerFramework
//
//  Created by Mark Sinkovics on 3/8/13.
//
//

#import "PWMsgControlRequest.h"

@implementation PWMsgControlRequest

@synthesize enableScreenSharing = _enableScreenSharing;
@synthesize enableRemoteDevice = _enableRemoteDevice;

+ (NSSet*)mappedProperties
{
	return [NSSet setWithArray:@[@"enableScreenSharing", @"enableRemoteDevice"]];
}

@end
