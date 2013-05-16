//
//  PWTCPPeer.m
//  PassagewayServerMac
//
//  Created by Mark Sinkovics on 9/30/12.
//
//

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

@interface PWTCPPeer ()

@property (nonatomic, assign,	readwrite) AsyncSocket* tcpSocket;
@property (nonatomic, copy,		readwrite) NSString *host;
@property (nonatomic, assign,	readwrite) UInt16 port;
@property (nonatomic, strong,	readwrite) PWTCPBuffer* tcpBuffer;

@end

@implementation PWTCPPeer

@synthesize tcpSocket	= _tcpSocket;
@synthesize host		= _host;
@synthesize port		= _port;
@synthesize tcpBuffer	= _tcpBuffer;

#pragma mark - Memory Management

- (void)dealloc
{
    self.tcpSocket = nil;
	
	self.tcpSocket = nil;
		
	self.ipAddress = nil;
	
	self.host = nil;
	
	NSLog(@"%s", __PRETTY_FUNCTION__);
	
    [super dealloc];
}

#pragma mark - Data Handling

- (void)sendData:(NSData*)data
{
	[self.tcpBuffer sendData:data];
}

#pragma mark - Disconnection

- (void)disconnect
{
	[self.tcpBuffer disconnect];
	
	self.tcpSocket = nil;
	
	[super disconnect];
}

@end

@implementation PWTCPPeer (Server)

- (void)connectAsyncSocket:(AsyncSocket*)socket
{
	self.tcpSocket = socket;
	
	self.tcpBuffer = [PWTCPBuffer tcpBufferWithDelegate:self asyncTCPSocket:self.tcpSocket];
}

#pragma mark - NSNetServiceDelegate

- (void)netServiceDidResolveAddress:(NSNetService *)sender
{
	[self.ipAddress updateIPsAddressAndPortWithNetService:self.netService];
	
	self.port = self.ipAddress.IPv4Port;
	
	self.host = self.ipAddress.IPv4Address;
	
	self.tcpSocket = [[[AsyncSocket alloc] init] autorelease];
	
	self.tcpBuffer = [PWTCPBuffer tcpBufferWithDelegate:self asyncTCPSocket:self.tcpSocket];
	
	NSError* connectionError = nil;
	
	[self.tcpSocket connectToAddress:[[sender addresses] objectAtIndex:0] error:&connectionError];
	
	if (connectionError)
	{
		[self updateStatus:PWBasePeerStatusTypeError andMsg:connectionError.localizedDescription];
	}
}

- (void)netService:(NSNetService *)sender didNotResolve:(NSDictionary *)errorDict
{
	[self updateStatus:PWBasePeerStatusTypeError andMsg:[NSString stringWithFormat:@"[ERROR] %@", errorDict]];
}

- (void)welcome
{
	[self setStatusCode:255];
	
	unsigned char code = 255;
	
	NSData *welcomeMsg = [NSData dataWithBytes:&code length:1];
	
	[self.tcpBuffer sendData:welcomeMsg withTag:2];
}

@end

@implementation PWTCPPeer (Client)

- (void)connectToHost:(NSString *)host port:(UInt16)port
{
	self.tcpSocket = [[[AsyncSocket alloc] init] autorelease];
	
	self.tcpBuffer = [PWTCPBuffer tcpBufferWithDelegate:self asyncTCPSocket:self.tcpSocket];
	
	self.host = host;
	
	self.port = port;
	
	NSError* connectionError = nil;
	
	[self.tcpSocket connectToHost:self.host onPort:self.port error:&connectionError];
	
	if (connectionError)
	{
		[self updateStatus:PWBasePeerStatusTypeError andMsg:connectionError.localizedDescription];
	}
}

@end