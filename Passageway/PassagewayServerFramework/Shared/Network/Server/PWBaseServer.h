//
//  PWBaseServer.h
//  PassagewayServerFramework
//
//  Created by Mark Sinkovics on 1/11/13.
//
//

#import <Foundation/Foundation.h>
#import "PWBaseServerDelegate.h"
#import "PWDelegateController.h"
#import "PWBasePeer.h"
#import "PWBasePeerDelegate.h"

@interface PWBaseServer : NSObject <PWBasePeerDelegate>
{
	PWDelegateController* _delegate;
	
	NSString* _bonjourDomain;
	NSString* _bonjourType;
	NSString* _bonjourName;
	
	NSMutableArray* _peers;
	
	NSTimer* _timer;

	struct {
		unsigned int active:1;
		unsigned int enableConnectionTest:1;
	} __base_flag;
}

@property (nonatomic, strong, readonly) PWDelegateController* delegate;

@property (nonatomic, copy, readonly)	NSString* bonjourDomain;
@property (nonatomic, copy, readonly)	NSString* bonjourType;
@property (nonatomic, copy)				NSString* bonjourName;

@property (nonatomic, strong, readonly) NSMutableArray* peers;

#pragma mark - Server Create Methods

- (id)initWithDomain:(NSString*)domain type:(NSString *)type name:(NSString *)name;

#pragma mark - Server Control Methods

- (void)start;

- (void)stopByUser;

- (void)stopWitReason:(NSError*)error;

- (void)removePeer:(PWBasePeer*)peer;

#pragma mark - Status Methods

- (BOOL)isActive;

- (void)connectionTestingEnable:(BOOL)enable;

#pragma mark - Connect/Disconnect

- (NSArray*)connectedPeers;

- (void)connectToPeers:(NSArray*)peers;

- (void)disconnectFromPeers:(NSArray*)peers;

#pragma mark - Data Sending Methods

- (void)unicastData:(NSData*)data toPeer:(PWBasePeer*)peer;

- (void)multicastData:(NSData*)data toPeers:(NSArray*)peer;

- (void)broadcastData:(NSData*)data;

@end
