//
//  PWMsgAccessRequest.h
//  PassagewayServerFramework
//
//  Created by Mark Sinkovics on 3/3/13.
//
//

#import <Foundation/Foundation.h>
#import "MSJSONMapperProtocol.h"

@interface PWMsgAccessRequest : NSObject<MSJSONMapperProtocol>
{
	NSString* _username;
	NSString* _password;
}

@property (nonatomic, strong) NSString* username;
@property (nonatomic, strong) NSString* password;

@end
