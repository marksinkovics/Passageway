//
//  PWIPAddress.h
//  PassagewayServerMac
//
//  Created by Mark Sinkovics on 10/10/12.
//
//

/*!
 @header PWIPAddress.h
 @compilerflag
 @discussion
 @updated 10/10/12
 @copyright	10/10/12 Mark Sinkovics
 @textblock
 @/textblock
 */

#import <Foundation/Foundation.h>
#import <sys/types.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <netinet6/in6.h>

/*!
 @class PWIPAddress
 @discussion This is a discussion.
 It can span many lines or paragraphs.
 */
@interface PWIPAddress : NSObject <NSCopying>
{
	NSString *_IPv4Address;
	NSString *_IPv6Address;
	unsigned int _IPv4Port;
	unsigned int _IPv6Port;
	
	NSMutableArray* _addresses;
}

@property (nonatomic, strong, readonly) NSString *IPv4Address, *IPv6Address;
@property (nonatomic, assign, readonly) unsigned int IPv4Port, IPv6Port;
@property (nonatomic, strong, readonly) NSMutableArray *addresses;

#pragma mark - Class Methods

/*!
 @method ipAddressWithCFSocketNativeHandle
 @param socketNativeHandle
 @return an intance of PWIPAddress
 */
+ (PWIPAddress*)ipAddressWithCFSocketNativeHandle:(CFSocketNativeHandle)socketNativeHandle;

/*!
 @method ipAddress
 @return an intance of PWIPAddress
 */
+ (PWIPAddress*)ipAddress;

#pragma mark - Instance Methods

- (id)init;

- (id)initWithCFSocketNativeHandle:(CFSocketNativeHandle)socketNativeHandle;

- (void)updateIPsAddressAndPortWithNetService:(NSNetService*)netService;

- (void)updateIPsAddressAndPortFromSocketAddress:(struct sockaddr_in*)socketAddress;

- (void)updateIPsAddressAndPortFromData:(NSData*)addressData;

- (BOOL)isEqualIPAddress:(PWIPAddress*)ipAddress;

- (BOOL)isOnlyIPv6;

@end
