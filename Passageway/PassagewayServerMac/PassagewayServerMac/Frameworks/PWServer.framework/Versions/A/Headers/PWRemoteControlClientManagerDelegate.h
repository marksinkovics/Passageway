//
//  PWRemoteControlClientManagerDelegate.h
//  PassagewayServerFramework
//
//  Created by Mark Sinkovics on 4/11/13.
//
//

@class PWRemoteControlClientManager;

@protocol PWRemoteControlClientManagerDelegate <NSObject>

@optional

#pragma mark - General Delegate Methods

- (NSString*)usernameForManager:(PWRemoteControlClientManager *)manager;

- (NSString*)manager:(PWRemoteControlClientManager *)manager passwordForUsername:(NSString*)username;

- (void)manager:(PWRemoteControlClientManager*)manager didFindPeers:(NSArray*)peers;

- (void)manager:(PWRemoteControlClientManager*)manager didConnectToControlServer:(PWTCPPeer*)tcpPeer;

- (void)manager:(PWRemoteControlClientManager*)manager accessGrantedWithResponse:(PWMsgAccessResponse*)accessResponse;

- (void)manager:(PWRemoteControlClientManager*)manager accessDeniedWithResponse:(PWMsgAccessResponse*)accessResponse;

#pragma mark - Screen Sharing Delegate Methods

//- (void)manager:(PWRemoteControlClientManager*)manager didEnableScreenSharing:(NSNumber*)enabled;

- (void)manager:(PWRemoteControlClientManager*)manager didReceiveScreenSharingResponse:(PWMsgControlResponse*)controlResponse;

- (void)manager:(PWRemoteControlClientManager*)manager didReceiveScreenSharingData:(NSData*)data;

#pragma mark - Remote Device Delegate Methods

- (NSData*)remoteDeviceDataForDeviceType:(PWCommunicationRemoteDeviceType)deviceType toManager:(PWRemoteControlClientManager*)manager;

#pragma mark - Screen Sharing & Remote Devices Delegate Methods

- (void)manager:(PWRemoteControlClientManager*)manager didEnableScreenSharing:(NSNumber*)screenSharingEnabled didEnableRemoteDevice:(NSNumber*)remoteDeviceEnabled;

@end
