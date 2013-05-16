//
//  PWCommunicationManager.h
//  PassagewayServerFramework
//
//  Created by Mark Sinkovics on 3/8/13.
//
//

#import "PWBaseManager.h"
#import "PWBaseServerDelegate.h"

#import "MSJSONMapperManager.h"

#import "PWMsgAccessRequest.h"
#import "PWMsgAccessResponse.h"
#import "PWMsgControlRequest.h"
#import "PWMsgControlResponse.h"

#import "PWTCPServer.h"
#import "PWUDPServer.h"
#import "PWTCPPeer.h"
#import "PWUDPPeer.h"

#import "PWBasePeerDelegate.h"
#import "PWBaseServerDelegate.h"

typedef enum _PWCommunicationRemoteDeviceType
{
	PWCommunicationRemoteDeviceTypeMouse	= 1,
	PWCommunicationRemoteDeviceTypeKeyboard = 2
	
} PWCommunicationRemoteDeviceType;

/*!
 @class PWCommunicationManager
 @discussion It is a normal PWBaseManager, but it is extended with the PWBaseServerDelegate methods
 */
@interface PWCommunicationManager : NSObject <PWBaseServerDelegate>
{
	dispatch_queue_t _private_concurrent_queue;
	dispatch_queue_t _private_serial_queue;
}

#pragma mark - Class Methods

+ (id)manager;

#pragma mark - Instance Methods

/*!
 @method start
 */
- (void)start;

/*!
 @method stop
 */
- (void)stop;

/*!
 @method active
 */
- (BOOL)active;

@end

#define IS_TCP_SERVER(__server__) ([__server__ isKindOfClass:[PWTCPServer class]])
#define IS_UDP_SERVER(__server__) ([__server__ isKindOfClass:[PWUDPServer class]])
#define IS_TCP_PEER(__peer__) ([__peer__ isKindOfClass:[PWTCPPeer class]])
#define IS_UDP_PEER(__peer__) ([__peer__ isKindOfClass:[PWUDPPeer class]])