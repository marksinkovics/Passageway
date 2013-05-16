//
//  PWMsgControlRequest.h
//  PassagewayServerFramework
//
//  Created by Mark Sinkovics on 3/8/13.
//
//

#import <Foundation/Foundation.h>
#import "MSJSONMapperProtocol.h"

@interface PWMsgControlRequest : NSObject<MSJSONMapperProtocol>
{
	NSNumber* _enableScreenSharing;
	NSNumber* _enableRemoteDevice;
}

@property (nonatomic, strong) NSNumber* enableScreenSharing;
@property (nonatomic, strong) NSNumber* enableRemoteDevice;

@end
