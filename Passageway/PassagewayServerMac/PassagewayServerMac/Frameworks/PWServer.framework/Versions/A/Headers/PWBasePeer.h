//
//  PWBasePeer.h
//  PassagewayServerFramework
//
//  Created by Mark Sinkovics on 1/28/13.
//
//

#import <Foundation/Foundation.h>
#import "PWBaseBufferDelegate.h"
#import "PWIPAddress.h"
#import "PWBasePeerDelegate.h"


@interface PWBasePeer : NSObject <PWBaseBufferDelegate, NSNetServiceDelegate>
{
	NSData* _receivedData; //this contains the lastest received data.
	PWIPAddress* _ipAddress;
	id<PWBasePeerDelegate> _delegate;
	NSNetService*	_netService;
	NSString* _uuid;
	struct {
		unsigned int connected:1;
		unsigned char status;
	} __flag;
}

@property (nonatomic, assign) id<PWBasePeerDelegate> delegate;
@property (nonatomic, strong) NSData* receivedData;
@property (nonatomic, strong) PWIPAddress* ipAddress;
@property (nonatomic, strong) NSNetService* netService;

/*!
 @property uuid
 */
@property (nonatomic, strong, readonly) NSString* uuid;

#pragma mark - Class Methods

//+ (PWBasePeer*)peerWithDelegate:(id<PWBasePeerDelegate>)delegate;
//
//+ (PWBasePeer*)peerWithIPAddress:(PWIPAddress*)ipAddress delegate:(id<PWBasePeerDelegate>)delegate;
//
//+ (PWBasePeer*)peerWithCFSocketNativeHandle:(CFSocketNativeHandle)socketNativeHandle delegate:(id<PWBasePeerDelegate>)delegate;
//
//+ (PWBasePeer*)peerWithNetService:(NSNetService*)netService delegate:(id<PWBasePeerDelegate>)delegate;

#pragma mark - Instance Methods

- (id)initWithNetService:(NSNetService*)netService;

#pragma mark - Status

- (void)updateStatus:(PWBasePeerStatusType)status andMsg:(NSString *)msg;

- (BOOL)connected;

- (void)connect;

- (void)disconnect;

- (void)setStatusCode:(unsigned char)status;

#pragma mark - Description

- (NSString*)name;

#pragma mark - Data Handling

- (void)sendData:(NSData*)data;

@end
