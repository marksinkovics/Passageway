//
//  PWMainController.h
//  PassagewayServerMac
//
//  Created by Mark Sinkovics on 4/14/13.
//
//

#import <Foundation/Foundation.h>
#import <PWServer/PWServer.h>

@interface PWMainController : NSObject  <PWRemoteControlServerManagerDelegate>
{
	PWRemoteControlServerManager* _serverManager;
	
	int _sizeImageContainer;
	
	NSData** _imageContainer;
	
	CGImageRef* _oldCGImages;
	
	NSTimer* _scheduler;
	
	dispatch_queue_t _private_queue;
}

- (void)startStop;

- (BOOL)isActive;

@end
