//
//  PWIPAddress.m
//  PassagewayServerMac
//
//  Created by Mark Sinkovics on 10/10/12.
//
//

#import "PWIPAddress.h"

//#import <CFNetwork/CFNetwork.h>
#import <sys/types.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <netinet6/in6.h>
#import <unistd.h>
#import <arpa/inet.h>
#import <netdb.h>

@interface PWIPAddress ()

@property (nonatomic, strong, readwrite) NSString *IPv4Address, *IPv6Address;
@property (nonatomic, assign, readwrite) unsigned int IPv4Port, IPv6Port;
@property (nonatomic, strong, readwrite) NSMutableArray *addresses;

@end

@implementation PWIPAddress

@synthesize IPv4Address = _IPv4Address;
@synthesize IPv6Address = _IPv6Address;
@synthesize IPv4Port = _IPv4Port;
@synthesize IPv6Port = _IPv6Port;

#pragma mark - Class Methods

+ (PWIPAddress*)ipAddressWithCFSocketNativeHandle:(CFSocketNativeHandle)socketNativeHandle
{
	PWIPAddress* ipAddress = [[PWIPAddress alloc] initWithCFSocketNativeHandle:socketNativeHandle];
	
	return [ipAddress autorelease];
}

+ (PWIPAddress*)ipAddress
{
	PWIPAddress* ipAddress = [[PWIPAddress alloc] init];
	
	return [ipAddress autorelease];
}

#pragma mark - Instance Methods

- (id)init
{
    self = [super init];
	
    if (self)
	{
		self.addresses = [NSMutableArray array];
    }
    return self;
}

- (id)initWithCFSocketNativeHandle:(CFSocketNativeHandle)socketNativeHandle
{
    self = [self init];
	
    if (self)
	{
		uint8_t name[SOCK_MAXADDRLEN];
		
		socklen_t namelen = sizeof(name);
		
		struct sockaddr* _addr = (struct sockaddr*)name;
		
		getpeername(socketNativeHandle, _addr, &namelen);
		
		struct sockaddr_in* socketAddress = (struct sockaddr_in*)_addr;
		
		[self updateIPsAddressAndPortFromSocketAddress:socketAddress];
		
    }
    return self;
}

#pragma mark - Memory Management

- (void)dealloc
{
    self.IPv4Address = nil;
	
	self.IPv6Address = nil;
	
	self.addresses = nil;
	
    [super dealloc];
}

#pragma mark - Coping

- (id)copyWithZone:(NSZone *)zone
{
	PWIPAddress *ipAddress = [[[self class] allocWithZone:zone] init];
	
	ipAddress.IPv4Address = [[self.IPv4Address copyWithZone:zone] autorelease];
	
	ipAddress.IPv6Address = [[self.IPv6Address copyWithZone:zone] autorelease];
	
	ipAddress.IPv4Port = self.IPv4Port;
	
	ipAddress.IPv6Port = self.IPv6Port;
	
	ipAddress.addresses = [[[NSMutableArray alloc] initWithArray:self.addresses copyItems:YES] autorelease];
    
    return ipAddress;
}

#pragma mark - Update Methods

- (void)updateIPsAddressAndPortWithNetService:(NSNetService*)netService
{	
	for (NSData* data in netService.addresses)
	{
		struct sockaddr_in* socketAddress = (struct sockaddr_in*) [data bytes];
		
		[self updateIPsAddressAndPortFromSocketAddress:socketAddress];
	}
}

- (void)updateIPsAddressAndPortFromData:(NSData*)addressData
{	
	[self updateIPsAddressAndPortFromSocketAddress:(struct sockaddr_in*)[addressData bytes]];
}

- (void)updateIPsAddressAndPortFromSocketAddress:(struct sockaddr_in*)socketAddress
{
	NSData* addressData = [NSData dataWithBytes:socketAddress length:sizeof(struct sockaddr_in)];
	
	[self.addresses removeAllObjects];
	
	[self.addresses addObject:addressData];
	
	//struct sockaddr_in* socketAddress = (struct sockaddr_in*) [addressData bytes];
	
	if (socketAddress->sin_family == AF_INET)
	{
		[self resolveIPv4AddressFrom:socketAddress];
		
		[self resolveIPv4PortFrom:socketAddress];
	}
	else if (socketAddress->sin_family == AF_INET6)
	{
		[self resolveIPv6AddressFrom:socketAddress];
		
		[self resolveIPv6PortFrom:socketAddress];
	}
}

- (void)resolveIPv4AddressFrom:(struct sockaddr_in*)addr_in
{	
	char straddr[INET_ADDRSTRLEN];
	
	inet_ntop(AF_INET, &addr_in->sin_addr, straddr, sizeof(straddr));
	
	self.IPv4Address = [NSString stringWithCString:straddr encoding:NSUTF8StringEncoding];
}

- (void)resolveIPv6AddressFrom:(struct sockaddr_in*)addr_in
{
	char straddr[INET6_ADDRSTRLEN];
	
	inet_ntop(AF_INET6, &addr_in->sin_addr, straddr, sizeof(straddr));
	
	self.IPv6Address = [NSString stringWithCString:straddr encoding:NSUTF8StringEncoding];
}

- (void)resolveIPv4PortFrom:(struct sockaddr_in*)addr_in
{
	self.IPv4Port = (unsigned int)ntohs(addr_in->sin_port);
}

- (void)resolveIPv6PortFrom:(struct sockaddr_in*)addr_in
{
	self.IPv6Port =  (unsigned int)ntohs(addr_in->sin_port);
}

- (NSString*)description
{
	return [NSString stringWithFormat:@"[%@:%u|%@:%u]", self.IPv4Address, self.IPv4Port, self.IPv6Address, self.IPv6Port];
}

- (BOOL)isEqual:(id)object
{
	BOOL retVal = NO;
	
	if ([object isKindOfClass:[PWIPAddress class]])
	{
		retVal = [self isEqualIPAddress:(PWIPAddress*)object];
	}
	
	return retVal;
}

- (BOOL)isEqualIPAddress:(PWIPAddress*)ipAddress
{
	return (([ipAddress.IPv4Address isEqualToString:self.IPv4Address]
			 || [ipAddress.IPv6Address isEqualToString:self.IPv6Address])
			&& (ipAddress.IPv4Port == self.IPv4Port
				|| ipAddress.IPv6Port == self.IPv6Port));
}

- (BOOL)isOnlyIPv6
{
	return (self.IPv4Address == nil);
}

@end
