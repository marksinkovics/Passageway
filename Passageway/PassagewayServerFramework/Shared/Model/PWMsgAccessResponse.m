//
//  PWMsgAccessResponse.m
//  PassagewayServerFramework
//
//  Created by Mark Sinkovics on 3/3/13.
//
//

#import "PWMsgAccessResponse.h"

@implementation PWMsgAccessResponse
@synthesize accepted	= _accepted;
@synthesize uuid		= _uuid;

#pragma mark - MSJSONMapperProtocol

+ (NSSet*)mappedProperties
{
	return [NSSet setWithArray:@[@"accepted", @"uuid"]];
}

@end
