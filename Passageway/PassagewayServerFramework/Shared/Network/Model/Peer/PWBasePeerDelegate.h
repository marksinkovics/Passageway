//
//  PWBasePeerDelegate.h
//  PassagewayServerFramework
//
//  Created by Mark Sinkovics on 1/28/13.
//
//

#import <Foundation/Foundation.h>

@class PWBasePeer;

typedef enum _PWBasePeerStatusType
{
	PWBasePeerStatusTypeError = 0,		//0
	PWBasePeerStatusTypeConnected,		//1
	PWBasePeerStatusTypeDisconnected,	//2
	
} PWBasePeerStatusType;


@protocol PWBasePeerDelegate <NSObject>

- (void)didConnectPeer:(PWBasePeer*)peer;

- (void)didDisconnectedPeer:(PWBasePeer*)peer;

- (void)peer:(PWBasePeer*)peer failedWithError:(NSError*)error;

- (void)peer:(PWBasePeer*)peer didReceiveData:(NSData*)data;

- (void)peer:(PWBasePeer*)peer didWriteData:(NSData*)data;

@end
