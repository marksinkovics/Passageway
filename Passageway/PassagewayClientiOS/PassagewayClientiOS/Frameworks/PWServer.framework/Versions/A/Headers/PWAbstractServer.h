//
//  PWBaseServer.h
//  PassagewayServerFramework
//
//  Created by Mark Sinkovics on 1/3/13.
//
//

#import <Foundation/Foundation.h>
#import "PWBaseServer.h"
#import "PWDelegateController.h"
#import "PWBaseBufferDelegate.h"


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


@interface PWAbstractServer : PWBaseServer <NSNetServiceDelegate, PWBaseBufferDelegate>
{	
	NSNetService* _netService;
	
	unsigned int _port;
	
	BOOL _enableBonjour;
	
	struct {
		unsigned int activeService:1;
	} __abstract_flag;
}

@property (nonatomic, strong, readonly) NSNetService* netService;
@property (nonatomic, assign) unsigned int port;
@property (nonatomic, assign) BOOL enableBonjour;

#pragma mark - Server Custom Methods

- (BOOL)startIPv4;

- (BOOL)startIPv6;

- (BOOL)startNetService;

- (NSString *)hostIPv4;

- (NSString *)hostIPv6;

#pragma mark - Connection Handle

NSString * DisplayAddressForAddress(NSData * address);

void AcceptCallBack(CFSocketRef socket, CFSocketCallBackType type, CFDataRef address, const void *data, void *info);

// acceptConnectionWithCFSocketNativeHandle: will call the receiveWithCFSocketNativeHandle: method after, the authentication process will be success
- (void)acceptConnectionWithCFSocketNativeHandle:(CFSocketNativeHandle)socketNativeHandle;

- (void)receiveWithCFSocketNativeHandle:(CFSocketNativeHandle)socketNativeHandle;

@end