//
//  PWMsgControlResponse.h
//  PassagewayServerFramework
//
//  Created by Mark Sinkovics on 3/8/13.
//
//

#import <Foundation/Foundation.h>
#import "MSJSONMapperProtocol.h"

@interface PWMsgControlResponse : NSObject <MSJSONMapperProtocol>
{
	NSNumber* _screenSharingEnabled;
	NSNumber* _remoteDeviceEnabled;
	
	NSNumber* _numV;
	NSNumber* _numH;
	NSNumber* _sizeV;
	NSNumber* _sizeH;
	
	NSNumber* _scale;
	
	NSString* _hostIPv4;
	NSNumber* _portIPv4;
	NSString* _hostIPv6;
	NSNumber* _portIPv6;
}

@property (nonatomic, strong) NSNumber* screenSharingEnabled;
@property (nonatomic, strong) NSNumber* remoteDeviceEnabled;

@property (nonatomic, strong) NSNumber* numV;
@property (nonatomic, strong) NSNumber* numH;
@property (nonatomic, strong) NSNumber* sizeV;
@property (nonatomic, strong) NSNumber* sizeH;

@property (nonatomic, strong) NSNumber* scale;

@property (nonatomic, strong) NSString* hostIPv4;
@property (nonatomic, strong) NSNumber* portIPv4;
@property (nonatomic, strong) NSString* hostIPv6;
@property (nonatomic, strong) NSNumber* portIPv6;

@end
