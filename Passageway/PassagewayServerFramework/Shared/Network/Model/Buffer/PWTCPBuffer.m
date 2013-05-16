//
//  PWTCPBuffer.m
//  PassagewayServerFramework
//
//  Created by Mark Sinkovics on 12/27/12.
//
//

#import "PWTCPBuffer.h"

#import "NSString+Utilities.h"
#import "PWIPAddress.h"

#include <netdb.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <stdio.h>


#if TARGET_OS_EMBEDDED || TARGET_IPHONE_SIMULATOR
#import <CFNetwork/CFNetwork.h>
#else
#import <CoreServices/CoreServices.h>
#endif

#import "PWIPAddress.h"

@implementation PWTCPBuffer

@synthesize tcpSocket = _tcpSocket;

#pragma mark - Class Methods

+ (PWTCPBuffer*)tcpBufferWithDelegate:(id<PWBaseBufferDelegate>)delegate asyncTCPSocket:(AsyncSocket*)tcpSocket
{
	PWTCPBuffer* tcpBuffer = [[PWTCPBuffer alloc] initWithDelegate:delegate asyncSocket:tcpSocket];
	
	return [tcpBuffer autorelease];
}

#pragma mark - Instance Methods

- (id)initWithDelegate:(id<PWBaseBufferDelegate>)delegate asyncSocket:(AsyncSocket*)asyncSocket
{
	self = [super initWithDelegate:delegate];
	
	if (self)
	{
		self.tcpSocket = asyncSocket;

		[self.tcpSocket setDelegate:self];
				
		[self.tcpSocket readDataWithTimeout:-1 tag:0];
		
		self.buffer = [NSMutableData data];
		
	}
	
	return self;
}

- (void)dealloc
{
	NSLog(@"%s", __PRETTY_FUNCTION__);
	
	[self.tcpSocket setDelegate:nil];
	
	[self.tcpSocket disconnect];
	
    self.tcpSocket = nil;
	
	self.buffer = nil;
	
    [super dealloc];
}

- (void)sendData:(NSData *)data
{
	[self sendData:data withTag:0];
}

- (void)sendData:(NSData *)data withTag:(unsigned int)tag
{
	NSMutableData* packedData = [self packData:data withTag:tag];
	
	[self.tcpSocket writeData:packedData withTimeout:-1 tag:0];
	
	[self.tcpSocket readDataWithTimeout:-1 tag:0];
}

- (void)disconnect
{
	NSLog(@"%s", __PRETTY_FUNCTION__);
	
	[self.tcpSocket setDelegate:nil];
	
	[self.tcpSocket disconnect];
	
    self.tcpSocket = nil;
}

#pragma mark - AsyncSocketDelegate Methods

- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
	@autoreleasepool
	{
		[self.buffer appendData:data];
		
		BOOL hasMoreData = NO;
		
		do {
			
			@autoreleasepool
			{
				PWBufferHeader _receivedHeader = {0, 0};
				
				NSMutableData* _receivedData = [self unpackData:self.buffer intoHeader:&_receivedHeader];
				
				if (_receivedData)
				{
					BOOL hasStatusCode = NO;
					
					unsigned char statusCode = 0;
					
					if (_receivedHeader.tag == 2)
					{
						hasStatusCode = YES;
						
						[_receivedData getBytes:&statusCode length:1];
					}
					
					NSUInteger startPos = (_receivedHeader.size + sizeof(PWBufferHeader));
					
//					NSRange dataRange = NSMakeRange(startPos, self.buffer.length - startPos);
					
					[self.buffer replaceBytesInRange:NSMakeRange(0, startPos) withBytes:NULL length:0];
					
//					self.inputBuffer = [NSMutableData dataWithData:[self.buffer subdataWithRange:dataRange]];
					
					if (hasStatusCode)
					{
						[self.delegate invokeSelector:@selector(buffer:didChangeStatus:) withParameters:@[self, @(statusCode)]];
					}
					else
					{
						[self.delegate invokeSelector:@selector(buffer:didReadData:) withParameters:@[self, _receivedData]];
					}
					
					hasMoreData = (self.buffer.length > sizeof(PWBufferHeader));
				}
				else
				{
					break;
				}
			}
			
		} while (hasMoreData);
	}
	
	[self.tcpSocket readDataWithTimeout:-1 tag:0];
}

- (void)onSocket:(AsyncSocket *)sock didReadPartialDataOfLength:(NSUInteger)partialLength tag:(long)tag
{

}

- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag
{
	[self.delegate invokeSelector:@selector(buffer:didWriteData:) withParameters:@[self, [NSData data]]];
}

- (void)onSocket:(AsyncSocket *)sock didWritePartialDataOfLength:(NSUInteger)partialLength tag:(long)tag
{
	
}

- (void)onSocket:(AsyncSocket *)sock didAcceptNewSocket:(AsyncSocket *)newSocket
{
	
}

- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
	[self.tcpSocket readDataWithTimeout:-1 tag:0];
	
	[self.delegate invokeSelector:@selector(didConnectAtBuffer:) withParameters:@[self]];
}

- (void)onSocketDidDisconnect:(AsyncSocket *)sock
{
	[self disconnect];
	
	[self.delegate invokeSelector:@selector(didDisconnectAtBuffer:) withParameters:@[self]];
}

- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)error
{
	[self disconnect];
	
	NSError* _error = error ? error : [NSError errorWithDomain:@"Disconnected Peer Error" code:-1 userInfo:nil];
	
	[self.delegate invokeSelector:@selector(buffer:didFailWithError:) withParameters:@[self, _error]];
}

@end
