//
//  PWBaseServerDelegate.h
//  PassagewayServerFramework
//
//  Created by Mark Sinkovics on 1/18/13.
//
//

#import <Foundation/Foundation.h>

@class PWBaseServer;
@class PWBasePeer;
@class PWIPAddress;

@protocol PWBaseServerDelegate <NSObject>

@optional
- (void)server:(PWBaseServer*)server didStartWithInfo:(NSString*)info;

- (void)server:(PWBaseServer*)server didStopWithReason:(NSError*)error;

- (void)server:(PWBaseServer*)server didConnectToPeer:(PWBasePeer*)peer;

- (void)server:(PWBaseServer*)server didDisconnectFromPeer:(PWBasePeer*)peer;

- (void)server:(PWBaseServer*)server didReceiveData:(NSData*)data fromPeer:(PWBasePeer*)peer;

- (void)server:(PWBaseServer*)server didUpdatePeerList:(NSArray*)peerList;

@end
