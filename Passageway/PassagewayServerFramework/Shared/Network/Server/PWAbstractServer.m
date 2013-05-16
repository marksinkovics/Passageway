//
//  PWBaseServer.m
//  PassagewayServerFramework
//
//  Created by Mark Sinkovics on 1/3/13.
//
//

#import "PWAbstractServer.h"

#import <sys/types.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <netinet6/in6.h>
#import <unistd.h>
#import <arpa/inet.h>
#import <netdb.h>
#include <ifaddrs.h>

@interface PWAbstractServer ()

@property (nonatomic, strong, readwrite) NSNetService* netService;

@end

@implementation PWAbstractServer

@synthesize netService		= _netService;
@synthesize port			= _port;
@synthesize enableBonjour	= _enableBonjour;

#pragma mark - Memory Management

- (void)dealloc
{	
    //[self stopWitReason:[NSError errorWithDomain:@"Object will be deallocated" code:-1 userInfo:nil]];
	
    [super dealloc];
}

#pragma mark - PWAbstractServer Override Methods

- (void)start
{
	[super start];
	
	BOOL startedIPv4 = [self startIPv4];
	
	BOOL startedIPv6 = [self startIPv6];
	
	if (startedIPv4 && startedIPv6)
	{
		BOOL startedNetService = YES;
		
		if (self.enableBonjour)
		{
			startedNetService = [self startNetService];
		}
		
		if (startedNetService)
		{
			[self.delegate invokeSelector:@selector(server:didStartWithInfo:) withParameters:@[self, [NSString stringWithFormat:@"%u", self.port]]];
		}
	}
}

- (BOOL)startIPv4
{
	return NO;
}

- (BOOL)startIPv6
{
	return NO;
}

- (BOOL)startNetService
{
	if (!__abstract_flag.activeService  && !self.netService)
	{
		if (self.port > 0 && self.port < 65536)
		{
			self.netService = [[[NSNetService alloc] initWithDomain:self.bonjourDomain
															   type:self.bonjourType
															   name:self.bonjourName port:self.port] autorelease];
			
			[self.netService publishWithOptions:NSNetServiceNoAutoRename];
			
			__abstract_flag.activeService = YES;
		}
	}
	
	return __abstract_flag.activeService;
}

- (void)stopWitReason:(NSError *)error
{
	__abstract_flag.activeService = NO;
	
	self.netService = nil;

	[super stopWitReason:error];
}

- (NSString *)hostIPv4
{
	NSString *address = @"error";
	struct ifaddrs *interfaces = NULL;
	struct ifaddrs *temp_addr = NULL;
	int success = 0;
	
	// retrieve the current interfaces - returns 0 on success
	success = getifaddrs(&interfaces);
	if (success == 0)
	{
		// Loop through linked list of interfaces
		temp_addr = interfaces;
		
		while (temp_addr != NULL)
		{
			if( temp_addr->ifa_addr->sa_family == AF_INET)
			{
				// Check if interface is en0 which is the wifi connection on the iPhone
				if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en1"])
				{
					// Get NSString from C String
					address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
				}
				else if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"])
				{
					address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
				}
			}
			
			temp_addr = temp_addr->ifa_next;
		}
	}
	
	// Free memory
	freeifaddrs(interfaces);
	
	return address;
}

- (NSString *)hostIPv6
{
	NSString *address = @"error";
	struct ifaddrs *interfaces = NULL;
	struct ifaddrs *temp_addr = NULL;
	int success = 0;
	
	// retrieve the current interfaces - returns 0 on success
	success = getifaddrs(&interfaces);
	if (success == 0)
	{
		// Loop through linked list of interfaces
		temp_addr = interfaces;
		while (temp_addr != NULL)
		{
			if( temp_addr->ifa_addr->sa_family == AF_INET6)
			{
				// Check if interface is en0 which is the wifi connection on the iPhone
				if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en1"])
				{
					// Get NSString from C String
					address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
				}
				else if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"])
				{
					address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
				}
			}
			temp_addr = temp_addr->ifa_next;
		}
	}
	
	// Free memory
	freeifaddrs(interfaces);
	
	return address;
}

#pragma mark - Overrided Methods

- (void)setNetService:(NSNetService *)netService
{
	if (_netService != netService)
	{
		if (_netService)
		{
			_netService.delegate = nil;
			[_netService removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
			
			[_netService stop];
			[_netService release];
			_netService = nil;
		}
		
		if (netService)
		{
			_netService =  [netService retain];
			_netService.delegate = self;
			[_netService scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
		}
	}
}

#pragma mark - Private Methods

NSString * DisplayAddressForAddress(NSData * address)
// Returns a dotted decimal string for the specified address (a (struct sockaddr)
// within the address NSData).
{
    int         err;
    NSString *  result;
    char        hostStr[NI_MAXHOST];
    char        servStr[NI_MAXSERV];
    
    result = nil;
    
    if (address != nil) {
		
        // If it's a IPv4 address embedded in an IPv6 address, just bring it as an IPv4
        // address.  Remember, this is about display, not functionality, and users don't
        // want to see mapped addresses.
        
        if ([address length] >= sizeof(struct sockaddr_in6)) {
            const struct sockaddr_in6 * addr6Ptr;
            
            addr6Ptr = [address bytes];
            if (addr6Ptr->sin6_family == AF_INET6) {
                if ( IN6_IS_ADDR_V4MAPPED(&addr6Ptr->sin6_addr) || IN6_IS_ADDR_V4COMPAT(&addr6Ptr->sin6_addr) ) {
                    struct sockaddr_in  addr4;
                    
                    memset(&addr4, 0, sizeof(addr4));
                    addr4.sin_len         = sizeof(addr4);
                    addr4.sin_family      = AF_INET;
                    addr4.sin_port        = addr6Ptr->sin6_port;
                    addr4.sin_addr.s_addr = addr6Ptr->sin6_addr.__u6_addr.__u6_addr32[3];
                    address = [NSData dataWithBytes:&addr4 length:sizeof(addr4)];
                    assert(address != nil);
                }
            }
        }
        err = getnameinfo([address bytes], (socklen_t) [address length], hostStr, sizeof(hostStr), servStr, sizeof(servStr), NI_NUMERICHOST | NI_NUMERICSERV);
        if (err == 0) {
            result = [NSString stringWithFormat:@"%s:%s", hostStr, servStr];
            assert(result != nil);
        }
    }
	
    return result;
}

void AcceptCallBack(CFSocketRef socket, CFSocketCallBackType type, CFDataRef address, const void *data, void *info)
{
	PWAbstractServer* server = (PWAbstractServer *)info;
	
	switch (type)
	{
		case kCFSocketAcceptCallBack:
		{
			[server acceptConnectionWithCFSocketNativeHandle:*(CFSocketNativeHandle *)data];
		}
			break;
		default:
			break;
	}
}

// TODO: Authentication
- (void)acceptConnectionWithCFSocketNativeHandle:(CFSocketNativeHandle)socketNativeHandle
{
	[self receiveWithCFSocketNativeHandle:socketNativeHandle];
}

- (void)receiveWithCFSocketNativeHandle:(CFSocketNativeHandle)socketNativeHandle
{
    @throw [NSException exceptionWithName:NSGenericException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

#pragma mark - NetService Delegate

- (void)netService:(NSNetService *)sender didNotPublish:(NSDictionary *)errorDict
{
#pragma unused(sender)
    assert(sender == self.netService);
#pragma unused(errorDict)
	
	[self stopWitReason:[NSError errorWithDomain:@"Registration failed" code:-1 userInfo:nil]];
}

@end