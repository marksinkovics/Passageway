//
//  PWMsgControlResponse.m
//  PassagewayServerFramework
//
//  Created by Mark Sinkovics on 3/8/13.
//
//

#import "PWMsgControlResponse.h"

@implementation PWMsgControlResponse

@synthesize screenSharingEnabled	= _screenSharingEnabled;
@synthesize remoteDeviceEnabled		= _remoteDeviceEnabled;
@synthesize numV					= _numV;
@synthesize numH					= _numH;
@synthesize sizeV					= _sizeV;
@synthesize sizeH					= _sizeH;
@synthesize scale					= _scale;
@synthesize hostIPv4				= _hostIPv4;
@synthesize portIPv4				= _portIPv4;
@synthesize hostIPv6				= _hostIPv6;
@synthesize portIPv6				= _portIPv6;

+ (NSSet*)mappedProperties
{
	return [NSSet setWithArray:@[@"screenSharingEnabled", @"remoteDeviceEnabled", @"numV", @"numH", @"sizeV", @"sizeH", @"scale", @"hostIPv4", @"portIPv4",
			@"hostIPv6", @"portIPv6"]];
}

@end
