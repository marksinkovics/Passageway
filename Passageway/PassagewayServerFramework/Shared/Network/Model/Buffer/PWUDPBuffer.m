//
//  PWUDPBuffer.m
//  PassagewayServerFramework
//
//  Created by Mark Sinkovics on 1/28/13.
//
//

#import "PWUDPBuffer.h"

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

@implementation PWUDPBuffer

@synthesize udpSocket = _udpSocket;

#pragma mark - Class Methods

+ (PWUDPBuffer*)udpBufferWithDelegate:(id<PWBaseBufferDelegate>)delegate asyncUdpSocket:(AsyncUdpSocket*)udpSocket
{
	PWUDPBuffer* udpBuffer = [[PWUDPBuffer alloc] initWithDelegate:delegate asyncUdpSocket:udpSocket];
	
	return [udpBuffer autorelease];
}

#pragma mark - Instance Methods

- (id)initWithDelegate:(id<PWBaseBufferDelegate>)delegate asyncUdpSocket:(AsyncUdpSocket*)udpSocket
{
	self = [super initWithDelegate:delegate];
	
	if (self)
	{
		self.udpSocket = udpSocket;		
	}
	
	return self;
}

- (void)sendData:(NSData *)data toHost:(NSString *)host port:(UInt16)port
{
	self.buffer = [self packData:data];
	
	[self.udpSocket sendData:self.buffer toHost:host port:port withTimeout:10.0 tag:1];
}

#pragma mark - AsyncUdpSocketDelegate Methods

- (BOOL)onUdpSocket:(AsyncUdpSocket *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSString *)host port:(UInt16)port
{
	PWBufferHeader _receivedHeader;
	
	NSMutableData* _tempData = [self unpackData:data intoHeader:&_receivedHeader];
	
//	NSLog(@"_receivedHeader %hu", _receivedHeader.size);
	
	if (_tempData)
	{
		self.buffer = _tempData;
		
		[self.delegate invokeSelector:@selector(buffer:didReadData:) withParameters:@[self, self.buffer]];
	}
	else
	{
		NSError* error = [NSError errorWithDomain:@"Not valid data" code:-1 userInfo:nil];
		
		[self.delegate invokeSelector:@selector(buffer:didFailWithError:) withParameters:@[self, error]];
	}
	
	[sock receiveWithTimeout:-1 tag:0];
	
	return YES;
}

- (void)onUdpSocket:(AsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
	[self.delegate invokeSelector:@selector(buffer:didWriteData:) withParameters:@[self, _buffer]];
}

- (void)onUdpSocket:(AsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
	[self.delegate invokeSelector:@selector(buffer:didFailWithError:) withParameters:@[self, error]];
}

- (void)onUdpSocket:(AsyncUdpSocket *)sock didNotReceiveDataWithTag:(long)tag dueToError:(NSError *)error
{
	[self.delegate invokeSelector:@selector(buffer:didFailWithError:) withParameters:@[self, error]];
}

- (void)onUdpSocketDidClose:(AsyncUdpSocket *)sock
{
	
}



@end
