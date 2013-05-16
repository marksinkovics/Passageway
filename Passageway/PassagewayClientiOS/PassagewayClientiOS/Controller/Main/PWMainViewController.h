//
//  PWMainViewController.h
//  PassagewayClientiOS
//
//  Created by Mark Sinkovics on 4/7/13.
//  Copyright (c) 2013 mscodefactory. All rights reserved.
//

#import <PWServer/PWServer.h>

#import "PWPeersViewController.h"
#import "PWLoginViewController.h"

#import "PWRemoteDesktopViewController.h"
#import "PWRemoteMouseViewController.h"

@interface PWMainViewController : UIViewController <PWPeersViewControllerDelegate, PWLoginViewControllerDelegate, PWRemoteControlClientManagerDelegate>
{
	//UI
	
	__weak IBOutlet UIBarButtonItem* _connectItem;
	
	__weak IBOutlet UIButton* _remoteDesktopButton;
	
	__weak IBOutlet UIButton* _remoteMouseButton;
	
    UINavigationController* _peersVCInNavigationVC;
	
    PWPeersViewController*  _peersVC;
	
    UINavigationController* _loginVCInNavigationVC;
	
    PWLoginViewController*  _loginVC;
		
	// Logic
	
	PWRemoteControlClientManager* _clientManager;
	
    NSString* _username;
    NSString* _password;
	
    struct {
		unsigned int hasAccess:1;
		unsigned int serviceType:2; //0: none, 1: desktop & mouse, 2:mouse only
    } __flag;
}

@property (nonatomic, strong, readonly) PWRemoteControlClientManager* clientManager;

#pragma mark - Instance Methods

- (IBAction)connectButtonAction:(id)sender;

- (IBAction)startScreenSharingButtonAction:(id)sender;

- (IBAction)startMouseButtonAction:(id)sender;

#pragma mark - Test

- (IBAction)testAction:(id)sender;

@end
