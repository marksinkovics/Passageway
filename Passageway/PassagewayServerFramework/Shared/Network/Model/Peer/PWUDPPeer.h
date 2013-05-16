//
//  PWUDPPeer.h
//  PassagewayServerFramework
//
//  Created by Mark Sinkovics on 1/28/13.
//
//

#import "PWBasePeer.h"
#import "AsyncUdpSocket.h"
#import "PWUDPBuffer.h"

@interface PWUDPPeer : PWBasePeer
{
	AsyncUdpSocket* _udpSocket;
	NSString* _host;
	UInt16 _port;
	PWUDPBuffer* _udpBuffer;
}

@property (nonatomic, strong,	readonly) AsyncUdpSocket* udpSocket;
@property (nonatomic, copy,		readonly) NSString *host;
@property (nonatomic, assign,	readonly) UInt16 port;
@property (nonatomic, strong,	readonly) PWUDPBuffer* udpBuffer;

@end

#pragma mark PWUDPPeer Server extension

@interface PWUDPPeer (Server)

@end

#pragma mark PWUDPPeer Client extension

@interface PWUDPPeer (Client)

- (id)initWithHost:(NSString*)host port:(UInt16)port udpSocket:(AsyncUdpSocket*)udpSocket;

- (id)initWithHost:(NSString *)host port:(UInt16)port;

@end
