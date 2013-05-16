//
//  PWUDPPeer.m
//  PassagewayServerFramework
//
//  Created by Mark Sinkovics on 1/28/13.
//
//

#import "PWUDPPeer.h"

@interface PWUDPPeer ()

@property (nonatomic, strong,	readwrite) AsyncUdpSocket* udpSocket;
@property (nonatomic, copy,		readwrite) NSString *host;
@property (nonatomic, assign,	readwrite) UInt16 port;
@property (nonatomic, strong,	readwrite) PWUDPBuffer* udpBuffer;

@end

@implementation PWUDPPeer

@synthesize udpSocket	= _udpSocket;
@synthesize host		= _host;
@synthesize port		= _port;
@synthesize udpBuffer	= _udpBuffer;

#pragma mark - Memory Management

- (void)dealloc
{
    self.ipAddress = nil;
	
	self.udpBuffer = nil;
	
	[self.udpSocket close];
	
	self.udpSocket = nil;
	
	self.host = nil;
	
    [super dealloc];
}

#pragma mark - Data Handling

- (NSString*)activeHost
{
	NSString* host = self.host;
	
	return host;
}

- (int)activePort
{
	int port = self.port;
	
	return port;
}

- (void)sendData:(NSData*)data
{
	[self.udpBuffer sendData:data toHost:[self activeHost] port:[self activePort]];
}

@end

#pragma mark PWUDPPeer Server extension

@implementation PWUDPPeer (Server)

#pragma mark - NSNetServiceDelegate

- (void)netServiceDidResolveAddress:(NSNetService *)sender
{
	[self.ipAddress updateIPsAddressAndPortWithNetService:self.netService];
	
	self.port = self.ipAddress.IPv4Port;
	
	self.udpSocket = [[[AsyncUdpSocket alloc] init] autorelease];
	
	self.udpBuffer = [PWUDPBuffer udpBufferWithDelegate:self asyncUdpSocket:self.udpSocket];
	
	self.udpSocket.delegate = self.udpBuffer;
	
	__flag.connected = YES;
	
	[self updateStatus:PWBasePeerStatusTypeConnected andMsg:@"Connected"];
}

- (void)netService:(NSNetService *)sender didNotResolve:(NSDictionary *)errorDict
{
	[self updateStatus:PWBasePeerStatusTypeError andMsg:[NSString stringWithFormat:@"[ERROR] %@", errorDict]];
}

@end

#pragma mark PWUDPPeer Client extension

@implementation PWUDPPeer (Client)

#pragma mark - Initialize Methods

- (id)initWithHost:(NSString*)host port:(UInt16)port udpSocket:(AsyncUdpSocket*)udpSocket
{
    self = [super init];
	
    if (self)
	{
		self.host = host;
		
		self.port = port;
		
		self.udpSocket = udpSocket;
		
		self.udpBuffer = [PWUDPBuffer udpBufferWithDelegate:self asyncUdpSocket:self.udpSocket];
    }
    return self;
}

- (id)initWithHost:(NSString *)host port:(UInt16)port
{
    self = [super init];
	
    if (self)
	{
		self.host = host;
		
		self.port = port;
		
		self.udpSocket = [[[AsyncUdpSocket alloc] init] autorelease];
		
		self.udpBuffer = [PWUDPBuffer udpBufferWithDelegate:self asyncUdpSocket:self.udpSocket];
		
		self.udpSocket.delegate = self.udpBuffer;		
    }
    return self;
}

@end
