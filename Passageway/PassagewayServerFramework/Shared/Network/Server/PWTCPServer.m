//
//  PWTCPServer.m
//  PassagewayServerFramework
//
//  Created by Mark Sinkovics on 1/3/13.
//
//

#import "PWTCPServer.h"
#import "PWTCPPeer.h"

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

@interface PWTCPServer ()

@property (nonatomic, strong) AsyncSocket *tcpSocket;
@property (nonatomic, strong) NSMutableDictionary* peerDictionary;
@end

@implementation PWTCPServer


@synthesize tcpSocket = _tcpSocket;
@synthesize peerDictionary = _peerDictionary;

#pragma mark - Memory Management

- (void)dealloc
{
	self.tcpSocket = nil;
		
	self.peerDictionary = nil;

    [super dealloc];
}

#pragma mark - Getter Methods

- (AsyncSocket*)ipv4TCPSocket
{
	return self.tcpSocket;
}

- (AsyncSocket*)ipv6TCPSocket
{
	return self.tcpSocket;
}

#pragma mark - Start

- (BOOL)startIPv4
{
	if (self.tcpSocket == nil)
	{
		self.tcpSocket = [[[AsyncSocket alloc] initWithDelegate:self] autorelease];
		
		self.tcpSocket.delegate = self;
		
		NSError *error = nil;
		
		BOOL success = [self.tcpSocket acceptOnPort:0 error:&error];
		
		if (success)
		{
			self.port = [self.tcpSocket localPort];
		}
		else
		{
			[self stopWitReason:error];
		}
		
		return success;
	}
	else
	{
		return YES;
	}
}

- (BOOL)startIPv6
{	
	if (self.tcpSocket == nil)
	{
		self.tcpSocket = [[[AsyncSocket alloc] initWithDelegate:self] autorelease];
		
		self.tcpSocket.delegate = self;
		
		NSError *error = nil;
		
		BOOL success = [self.tcpSocket acceptOnPort:0 error:&error];
		
		if (success)
		{
			self.port = [self.tcpSocket localPort];
		}
		else
		{
			[self stopWitReason:error];
		}
		
		return success;
	}
	else
	{
		return YES;
	}
}

#pragma mark - Disconnection

- (void)stopWitReason:(NSError *)error
{
	[self.tcpSocket setDelegate:nil];
	
	[self.tcpSocket disconnect];
	
	self.tcpSocket = nil;
	
	[super stopWitReason:error];
}

#pragma mark - Private Methods

- (NSString*)_generateIdByAsyncSocket:(AsyncSocket*)socket
{
	return [NSString stringWithFormat:@"%@:%d", socket.connectedHost, socket.connectedPort];
}

- (PWTCPPeer*)_findPeerByAsyncSocket:(AsyncSocket*)socket
{
	if (self.peerDictionary == nil)
	{
		self.peerDictionary = [NSMutableDictionary dictionary];
	}
	
	NSString* _guid = [self _generateIdByAsyncSocket:socket];
	
	PWTCPPeer* peer = [self.peerDictionary objectForKey:_guid];
	
	if (peer == nil)
	{
		peer = [[PWTCPPeer alloc] init];
		
		peer.delegate = self;
		
		[peer connectAsyncSocket:socket];
		
		[self.peers addObject:peer];
		
		[self.peerDictionary setObject:peer forKey:_guid];
		
		[peer release];
	}
	
	return peer;
}

- (void)_removePeerByAsyncSocket:(AsyncSocket*)socket
{
	PWTCPPeer* peer = [self _findPeerByAsyncSocket:socket];
	
//	[peer disconnect];
	
	[self removePeer:peer];
	
//	NSString* _guid = [self _generateIdByAsyncSocket:socket];
//	
//	[self.peerDictionary removeObjectForKey:_guid];
//	
//	[self.peers removeObject:peer];
}

- (void)removePeer:(PWBasePeer*)peer
{
	NSString* peerKey = nil;
	
	for (NSString* key in self.peerDictionary)
	{
		if ([[self.peerDictionary objectForKey:key] isEqual:peer])
		{
			peerKey = key;
			
			break;
		}
	}
	
	if (peerKey)
	{
		[self.peerDictionary removeObjectForKey:peerKey];
	}
	
	[super removePeer:peer];
}

#pragma mark - AsyncSocketDelegate Methods

- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err
{
	[self.tcpSocket setDelegate:nil];
	
	[self.tcpSocket disconnect];
	
	self.tcpSocket = nil;
}

- (void)onSocketDidDisconnect:(AsyncSocket *)sock
{
	[self _removePeerByAsyncSocket:sock];
}

- (void)onSocket:(AsyncSocket *)sock didAcceptNewSocket:(AsyncSocket *)newSocket
{
	PWTCPPeer* peer = [self _findPeerByAsyncSocket:newSocket];
	
	[peer welcome];
}

//- (NSRunLoop *)onSocket:(AsyncSocket *)sock wantsRunLoopForNewSocket:(AsyncSocket *)newSocket
//{
//	
//}

//- (BOOL)onSocketWillConnect:(AsyncSocket *)sock
//{
//	
//}

- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
//	PWTCPPeer* peer = [self _findPeerByAsyncSocket:sock];
//	
//	[self.delegate invokeSelector:@selector(server:didConnectToPeer:) withParameters:@[self, peer]];
}

//- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
//{
//	
//}

//- (void)onSocket:(AsyncSocket *)sock didReadPartialDataOfLength:(NSUInteger)partialLength tag:(long)tag
//{
//	
//}

//- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag
//{
//	
//}

//- (void)onSocket:(AsyncSocket *)sock didWritePartialDataOfLength:(NSUInteger)partialLength tag:(long)tag
//{
//	
//}

//- (NSTimeInterval)onSocket:(AsyncSocket *)sock
//  shouldTimeoutReadWithTag:(long)tag
//                   elapsed:(NSTimeInterval)elapsed
//                 bytesDone:(NSUInteger)length
//{
//	
//}
//
//- (NSTimeInterval)onSocket:(AsyncSocket *)sock
// shouldTimeoutWriteWithTag:(long)tag
//                   elapsed:(NSTimeInterval)elapsed
//                 bytesDone:(NSUInteger)length
//{
//	
//}

//- (void)onSocketDidSecure:(AsyncSocket *)sock
//{
//	
//}

@end