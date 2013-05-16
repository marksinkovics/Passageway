//
//  PWTCPServer.h
//  PassagewayServerFramework
//
//  Created by Mark Sinkovics on 1/3/13.
//
//

#import "PWAbstractServer.h"
#import "AsyncSocket.h"

@interface PWTCPServer : PWAbstractServer <AsyncSocketDelegate>
{
	AsyncSocket	*_tcpSocket;
	NSMutableDictionary* _peerDictionary;
}

@property (nonatomic, readonly) AsyncSocket	*ipv4TCPSocket;
@property (nonatomic, readonly) AsyncSocket	*ipv6TCPSocket;

@end
