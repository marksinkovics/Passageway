//
//  PWUDPServer.m
//  PassagewayServerFramework
//
//  Created by Mark Sinkovics on 1/3/13.
//
//

#import "PWUDPServer.h"
#import "PWUDPPeer.h"

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

@interface PWUDPServer ()

@property (nonatomic, strong, readwrite) AsyncUdpSocket	*ipv4UDPSocket;
@property (nonatomic, strong, readwrite) AsyncUdpSocket	*ipv6UDPSocket;
@end

@implementation PWUDPServer

@synthesize ipv4UDPSocket = _ipv4UDPSocket;
@synthesize ipv6UDPSocket = _ipv6UDPSocket;

#pragma mark - Memory Management

- (void)dealloc
{
	[self.ipv4UDPSocket close];
	
	self.ipv4UDPSocket = nil;
	
	[self.ipv6UDPSocket close];
	
	self.ipv6UDPSocket = nil;
	
    [_peerDictionary removeAllObjects];
    
	[_peerDictionary release], _peerDictionary = nil;
	
    [super dealloc];
}

#pragma mark - Start

- (BOOL)startIPv4
{
	self.ipv4UDPSocket = [[[AsyncUdpSocket alloc] initIPv4] autorelease];
	
	self.ipv4UDPSocket.delegate = self;
	
	NSError *error = nil;
	
	BOOL success = [self.ipv4UDPSocket bindToPort:0 error:&error];
	
	if (success)
	{
		[self.ipv4UDPSocket receiveWithTimeout:-1 tag:0];
		
		self.port = [self.ipv4UDPSocket localPort];
	}
	else
	{
		[self stopWitReason:error];
	}
	
	return success;
}

- (BOOL)startIPv6
{
	self.ipv6UDPSocket = [[[AsyncUdpSocket alloc] initIPv6] autorelease];
	
	self.ipv6UDPSocket.delegate = self;
	
	NSError *error = nil;
	
	BOOL success = [self.ipv6UDPSocket bindToPort:self.port error:&error];
	
	if (success)
	{
		[self.ipv6UDPSocket receiveWithTimeout:-1 tag:0];
		
		if (!self.ipv4UDPSocket)
		{
			self.port = [self.ipv6UDPSocket localPort];
		}
	}
	else
	{
		[self stopWitReason:error];
	}
	
	return success;
}

- (PWUDPPeer*)peerForSock:(AsyncUdpSocket*)udpSocket withHost:(NSString*)host port:(UInt16)port
{
	if (!_peerDictionary)
	{
		_peerDictionary = [[NSMutableDictionary alloc] init];
	}
	
	NSString* _guid = [NSString stringWithFormat:@"%@:%d", host, port];
	
	PWUDPPeer* peer = [_peerDictionary objectForKey:_guid];
	
	if (peer == nil)
	{
		peer = [[PWUDPPeer alloc] initWithHost:host port:port udpSocket:udpSocket];
		
		peer.delegate = self;
		
		[self.peers addObject:peer];
		
		[_peerDictionary setObject:peer forKey:_guid];
		
		[peer release];
	}
	
	return peer;
}

- (BOOL)onUdpSocket:(AsyncUdpSocket *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSString *)host port:(UInt16)port
{
	PWUDPPeer* peer = [self peerForSock:sock withHost:host port:port];
	
	return [peer.udpBuffer onUdpSocket:sock didReceiveData:data withTag:tag fromHost:host port:port];
}

- (void)onUdpSocket:(AsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{

}

- (void)onUdpSocket:(AsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{

}

- (void)onUdpSocket:(AsyncUdpSocket *)sock didNotReceiveDataWithTag:(long)tag dueToError:(NSError *)error
{

}

- (void)onUdpSocketDidClose:(AsyncUdpSocket *)sock
{
	
}



@end
