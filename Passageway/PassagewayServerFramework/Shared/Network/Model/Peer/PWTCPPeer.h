//
//  PWTCPPeer.h
//  PassagewayServerMac
//
//  Created by Mark Sinkovics on 9/30/12.
//
//

#import "PWBasePeer.h"
#import "AsyncSocket.h"
#import "PWTCPBuffer.h"

@interface PWTCPPeer : PWBasePeer
{
	AsyncSocket* _tcpSocket;
	NSString* _host;
	UInt16 _port;
	PWTCPBuffer* _tcpBuffer;
}

@property (nonatomic, assign,	readonly) AsyncSocket* tcpSocket;
@property (nonatomic, copy,		readonly) NSString *host;
@property (nonatomic, assign,	readonly) UInt16 port;
@property (nonatomic, strong,	readonly) PWTCPBuffer* tcpBuffer;

@end

#pragma mark PWUDPPeer Server extension

@interface PWTCPPeer (Server)

- (void)connectAsyncSocket:(AsyncSocket*)socket;

- (void)welcome;

@end

#pragma mark PWUDPPeer Client extension

@interface PWTCPPeer (Client)

- (void)connectToHost:(NSString *)host port:(UInt16)port;

@end

