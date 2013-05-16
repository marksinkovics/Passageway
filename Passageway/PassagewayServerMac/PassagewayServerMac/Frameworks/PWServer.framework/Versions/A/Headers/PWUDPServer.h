//
//  PWUDPServer.h
//  PassagewayServerFramework
//
//  Created by Mark Sinkovics on 1/3/13.
//
//

#import "PWAbstractServer.h"
#import "AsyncUdpSocket.h"

/*!
 @class PWUDPServer
 */
@interface PWUDPServer : PWAbstractServer
{
	AsyncUdpSocket	*_ipv4UDPSocket;
	AsyncUdpSocket	*_ipv6UDPSocket;
	NSMutableDictionary* _peerDictionary;
}

@property (nonatomic, strong, readonly) AsyncUdpSocket	*ipv4UDPSocket;
@property (nonatomic, strong, readonly) AsyncUdpSocket	*ipv6UDPSocket;

@end
