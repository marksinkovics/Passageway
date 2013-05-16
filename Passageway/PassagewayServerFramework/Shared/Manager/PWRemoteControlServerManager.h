//
//  PWRemoteControlServerManager.h
//  PassagewayServerFramework
//
//  Created by Mark Sinkovics on 3/8/13.
//
//

#import "PWCommunicationManager.h"
#import "PWRemoteControlServerManagerDelegate.h"

/*!
 @class PWRemoteControlServerManager
 @discussion This manager is responsible to screen sharing.
 */
@interface PWRemoteControlServerManager : PWCommunicationManager
{
	PWTCPServer*			_controlServer;
	
	PWTCPServer*			_screenSharingServer;

	NSMutableArray*			_authenticatedPeers;
	
	id<PWRemoteControlServerManagerDelegate>	_delegate;
	
	float					_imageScale;
	
	struct {
		
		unsigned int screenSharing:1;
		unsigned int remoteDevice:1;
		
	} __flag;
}

@property (nonatomic, strong, readonly) PWTCPServer* controlServer;
@property (nonatomic, assign) id<PWRemoteControlServerManagerDelegate>	delegate;
@property (nonatomic, assign) float imageScale;

#pragma mark - Instance Methods

- (void)changeBonjourName:(NSString*)name;

- (void)sendSreenImage;

@end
