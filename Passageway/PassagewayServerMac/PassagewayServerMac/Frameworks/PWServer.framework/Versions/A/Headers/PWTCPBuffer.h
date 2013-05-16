//
//  PWTCPBuffer.h
//  PassagewayServerFramework
//
//  Created by Mark Sinkovics on 12/27/12.
//
//

#import "PWBaseBuffer.h"
#import "AsyncSocket.h"

@interface PWTCPBuffer : PWBaseBuffer <AsyncSocketDelegate>
{
	AsyncSocket* _tcpSocket;
}

@property (nonatomic, strong) AsyncSocket* tcpSocket;

#pragma mark - Class Methods

+ (PWTCPBuffer*)tcpBufferWithDelegate:(id<PWBaseBufferDelegate>)delegate asyncTCPSocket:(AsyncSocket*)tcpSocket;

#pragma mark - Instance Methods

- (void)sendData:(NSData *)data;

- (void)sendData:(NSData *)data withTag:(unsigned int)tag;

- (void)disconnect;

@end
