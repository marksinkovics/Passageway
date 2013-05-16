//
//  PWUDPBuffer.h
//  PassagewayServerFramework
//
//  Created by Mark Sinkovics on 1/28/13.
//
//

#import "PWBaseBuffer.h"
#import "AsyncUdpSocket.h"

@interface PWUDPBuffer : PWBaseBuffer <AsyncUdpSocketDelegate>
{
	AsyncUdpSocket* _udpSocket;
}

@property (nonatomic, strong) AsyncUdpSocket* udpSocket;

#pragma mark - Class Methods

+ (PWUDPBuffer*)udpBufferWithDelegate:(id<PWBaseBufferDelegate>)delegate asyncUdpSocket:(AsyncUdpSocket*)udpSocket;

#pragma mark - Instance Methods

- (id)initWithDelegate:(id<PWBaseBufferDelegate>)delegate asyncUdpSocket:(AsyncUdpSocket*)udpSocket;

- (void)sendData:(NSData *)data toHost:(NSString *)host port:(UInt16)port;

@end
