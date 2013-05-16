//
//  PWRemoteControlClientManager.h
//  PassagewayServerFramework
//
//  Created by Mark Sinkovics on 3/13/13.
//
//

#import "PWCommunicationManager.h"
#import "PWRemoteControlClientManagerDelegate.h"
#import "PWBrowseServer.h"
#import "PWDelegateController.h"

@interface PWRemoteControlClientManager : PWCommunicationManager <PWBasePeerDelegate>
{
	PWBrowseServer* _browseServer;
	PWTCPPeer*		_controlPeer;
	PWTCPPeer*		_screenSharingPeer;
	
	PWMsgAccessResponse* _accessResponse;
	id<PWRemoteControlClientManagerDelegate> _delegate;
	
	NSString* _username;
	NSString* _password;
	
	struct {
		unsigned int enabledScreenSharing:1;
		unsigned int enableRemoteDevice:1;
	} __flag;
}

@property (nonatomic, strong, readonly) PWBrowseServer* browseServer;
@property (nonatomic, strong, readonly) NSString* username;
@property (nonatomic, strong, readonly) NSString* password;
@property (nonatomic, assign) id<PWRemoteControlClientManagerDelegate> delegate;

#pragma mark - Instance Methods

- (void)enableScreenSharing:(BOOL)enableScreenSharing remoteDevice:(BOOL)enableRemoteDevice;

- (void)connectToPeer:(PWTCPPeer*)peer;

- (void)sendAccessRequest;

- (void)sendMouseData;

- (void)sendKeyboardData;

@end

