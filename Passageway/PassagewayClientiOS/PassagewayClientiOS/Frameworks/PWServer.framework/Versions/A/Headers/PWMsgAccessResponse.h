//
//  PWMsgAccessResponse.h
//  PassagewayServerFramework
//
//  Created by Mark Sinkovics on 3/3/13.
//
//

#import <Foundation/Foundation.h>
#import "MSJSONMapperProtocol.h"

@interface PWMsgAccessResponse : NSObject<MSJSONMapperProtocol>
{
	NSNumber* _accepted;
	NSString* _uuid;
}

@property (nonatomic, strong) NSNumber* accepted;
@property (nonatomic, strong) NSString* uuid;

@end
