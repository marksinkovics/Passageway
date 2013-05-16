//
//  PWAccessRequestModel.m
//  PassagewayServerFramework
//
//  Created by Mark Sinkovics on 3/3/13.
//
//

#import "PWMsgAccessRequest.h"

@implementation PWMsgAccessRequest
@synthesize username = _username;
@synthesize password = _password;

#pragma mark - MSJSONMapperProtocol

+ (NSSet*)mappedProperties
{
	return [NSSet setWithArray:@[@"username", @"password"]];
}

@end
