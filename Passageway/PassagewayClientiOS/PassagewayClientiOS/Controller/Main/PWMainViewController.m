//
//  PWMainViewController.m
//  PassagewayClientiOS
//
//  Created by Mark Sinkovics on 4/7/13.
//  Copyright (c) 2013 mscodefactory. All rights reserved.
//

#import "PWMainViewController.h"

@interface PWMainViewController ()

@property (nonatomic, strong, readwrite) PWRemoteControlClientManager* clientManager;

@property (nonatomic, weak) PWRemoteDesktopViewController* remoteDesktopViewController;

@property (nonatomic, weak) PWRemoteMouseViewController* remoteMouseViewController;
@end

@implementation PWMainViewController
{
	PWMsgControlResponse* _screenSharingResponse;
}

#pragma mark - Memory Management

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - View Handling

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	if (self.clientManager == nil)
    {
        self.clientManager = [PWRemoteControlClientManager manager];
        
        self.clientManager.delegate = self;
	}
	
	//UI
    
    _peersVCInNavigationVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PWPeersViewControllerInNavigationController"];
    
    _peersVC = (PWPeersViewController*)_peersVCInNavigationVC.topViewController;
    
    _peersVC.delegate = self;
    
    _loginVCInNavigationVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PWLoginViewControllerInNavigationController"];
    
	_loginVC = (PWLoginViewController*)_loginVCInNavigationVC.topViewController;
    
    _loginVC.delegate = self;
	
	_connectItem.title = NSLocalizedString(@"PWConnectKey", nil);
	
	[_remoteDesktopButton setTitle:NSLocalizedString(@"PWRemoteDesktopTitleKey", nil)
						  forState:UIControlStateNormal];
	
	[_remoteMouseButton setTitle:NSLocalizedString(@"PWRemoteMouseTitleKey", nil)
						forState:UIControlStateNormal];
	
	[self _remoteButtonsEnable:NO];
		
	// NotificationCenter
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(applicationWillResignActive:)
												 name:UIApplicationWillResignActiveNotification
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(applicationDidEnterBackground:)
												 name:UIApplicationDidEnterBackgroundNotification
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(applicationWillEnterForeground:)
												 name:UIApplicationWillEnterForegroundNotification
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(applicationDidBecomeActive:)
												 name:UIApplicationDidBecomeActiveNotification
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(applicationWillTerminate:)
												 name:UIApplicationWillTerminateNotification
											   object:nil];

}

#pragma mark - Storyboard

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"openRemoteDesktopViewController"])
	{
		self.remoteDesktopViewController = segue.destinationViewController;
		
		self.remoteDesktopViewController.clientManager = self.clientManager;
		
		self.remoteDesktopViewController.screenSharingResponse = _screenSharingResponse;
    }
	else if([segue.identifier isEqualToString:@"openRemoteMouseViewController"])
	{
		self.remoteMouseViewController = segue.destinationViewController;
		
		self.remoteMouseViewController.clientManager = self.clientManager;
	}
}


#pragma mark - User Action Methods

- (IBAction)connectButtonAction:(id)sender
{
	if ([self.clientManager active])
	{
		[self.clientManager stop];
		
		[self _serverConnectionIsClosed];
	}
	else
	{
		[self.clientManager start];
		
		[self presentViewController:_peersVCInNavigationVC animated:YES completion:nil];
	}
}

- (IBAction)startScreenSharingButtonAction:(id)sender
{
	if (__flag.hasAccess)
	{
		__flag.serviceType = 1;
		
		[self.clientManager enableScreenSharing:YES remoteDevice:YES];
	}
}

- (IBAction)startMouseButtonAction:(id)sender
{
	if (__flag.hasAccess)
	{
		__flag.serviceType = 2;
		
		[self.clientManager enableScreenSharing:NO remoteDevice:YES];
	}
}

#pragma mark - Test

- (IBAction)testAction:(id)sender
{
	[self performSegueWithIdentifier:@"openRemoteMouseViewController" sender:self];
}

#pragma mark - Private Methods

- (void)_serverConnectionIsOpen
{
	_connectItem.title = NSLocalizedString(@"PWDisconnectKey", nil);
}

- (void)_serverConnectionIsClosed
{
	_connectItem.title = NSLocalizedString(@"PWConnectKey", nil);
	
	__flag.hasAccess = NO;
	
	[self _remoteButtonsEnable:NO];
	
	[_peersVC updateListWithPeers:nil];
}

- (void)_showLogin
{	
    [self presentViewController:_loginVCInNavigationVC animated:YES completion:nil];
}

- (void)_remoteButtonsEnable:(BOOL)enable
{
	_remoteDesktopButton.enabled = enable;
	
	_remoteDesktopButton.alpha = enable ? 1.0 : 0.5;
	
	_remoteMouseButton.enabled = enable;
	
	_remoteMouseButton.alpha = enable ? 1.0 : 0.5;	
}

#pragma mark - PWInputViewControllerDelegate Methods

- (void)didShowViewController:(UIViewController*)viewController
{
    
}

- (void)didCancelViewController:(UIViewController*)viewController
{
	[viewController dismissViewControllerAnimated:YES completion:^{
		
		if ([self.clientManager active])
		{
			[self.clientManager stop];
			
			[self _serverConnectionIsClosed];
		}
		
	}];
}

- (void)didHideViewController:(UIViewController*)viewController
{
    
}

#pragma mark - PWPeersViewControllerDelegate Methods

- (void)viewController:(PWPeersViewController*)viewController didSelectPeer:(PWBasePeer*)peer
{
	[viewController dismissViewControllerAnimated:YES completion:^{
        
        [self.clientManager connectToPeer:(PWTCPPeer*)peer];
        
    }];
}

#pragma mark - PWLoginViewControllerDelegate Methods

- (void)viewController:(PWLoginViewController *)viewController didAddUsername:(NSString *)username withPassword:(NSString *)password
{
    _username = username;
    
    _password = password;
	
	[self.clientManager sendAccessRequest];
}

#pragma mark - PWRemoteControlClientManagerDelegate Methods

- (void)manager:(PWRemoteControlClientManager*)manager didFindPeers:(NSArray*)peers
{
	[_peersVC updateListWithPeers:peers];
}

- (void)manager:(PWRemoteControlClientManager*)manager didConnectToControlServer:(PWTCPPeer*)tcpPeer
{
	[self _serverConnectionIsOpen];
	
	[self _showLogin];
}

- (void)manager:(PWRemoteControlClientManager*)manager accessGrantedWithResponse:(PWMsgAccessResponse*)accessResponse
{
	__flag.hasAccess = YES;
	
	//TODO: put a HUD msg here
	[self _remoteButtonsEnable:YES];
	
	[_loginVC accessWasSuccessful:YES];
}

- (void)manager:(PWRemoteControlClientManager*)manager accessDeniedWithResponse:(PWMsgAccessResponse*)accessResponse
{
	[_loginVC accessWasSuccessful:NO];
	
//	[self _showLogin];
}

- (void)manager:(PWRemoteControlClientManager*)manager didReceiveScreenSharingResponse:(PWMsgControlResponse*)controlResponse
{
	_screenSharingResponse = controlResponse;
}

- (void)manager:(PWRemoteControlClientManager*)manager didReceiveScreenSharingData:(NSData*)data
{
	if (self.remoteDesktopViewController)
	{
		[self.remoteDesktopViewController manager:manager didReceiveScreenSharingData:data];
	}
}

- (NSString*)usernameForManager:(PWRemoteControlClientManager *)manager
{
	return _username;
}

- (NSString*)manager:(PWRemoteControlClientManager *)manager passwordForUsername:(NSString*)username
{
	return _password;
}

//- (void)manager:(PWRemoteControlClientManager*)manager didEnableMouse:(NSNumber*)enabled
//{
//	NSLog(@"%s", __PRETTY_FUNCTION__);
//}

- (void)manager:(PWRemoteControlClientManager*)manager didEnableScreenSharing:(NSNumber*)screenSharingEnabled didEnableRemoteDevice:(NSNumber *)remoteDeviceEnabled
{
	
	switch (__flag.serviceType) {
		case 0:
			break;
		case 1: // desktop & mouse
		{
			if (screenSharingEnabled.boolValue && remoteDeviceEnabled.boolValue)
			{
				[self performSegueWithIdentifier:@"openRemoteDesktopViewController" sender:self];
			}
			else
			{
				//TODO: create an alert view
				NSLog(@"Not allowed the screen sharing");
			}
		}
			break;
		case 2: // mouse only
		{
			if (remoteDeviceEnabled.boolValue)
			{
				[self performSegueWithIdentifier:@"openRemoteMouseViewController" sender:self];
			}
			else
			{
				//TODO: create an alert view
				NSLog(@"Not allowed the mouse");
			}
		}
			break;
	}
}

- (NSData*)remoteDeviceDataForDeviceType:(PWCommunicationRemoteDeviceType)deviceType toManager:(PWRemoteControlClientManager *)manager
{
	NSData* mouseData = [NSData data];
	
	if (self.remoteMouseViewController)
	{
		if ([self.remoteMouseViewController respondsToSelector:@selector(remoteDeviceDataForDeviceType:toManager:)])
		{
			mouseData = [self.remoteMouseViewController remoteDeviceDataForDeviceType:deviceType toManager:manager];
		}
	}
	else if (self.remoteDesktopViewController)
	{
		if ([self.remoteDesktopViewController respondsToSelector:@selector(remoteDeviceDataForDeviceType:toManager:)])
		{
			mouseData = [self.remoteDesktopViewController remoteDeviceDataForDeviceType:deviceType toManager:manager];
		}		
	}

	return mouseData;
}

#pragma mark - UIApplication Delegate Methods

// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
- (void)applicationWillResignActive:(UIApplication *)application
{
	
}

// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
- (void)applicationDidEnterBackground:(UIApplication *)application
{
	
}

// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
- (void)applicationWillEnterForeground:(UIApplication *)application
{
	
}

// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
- (void)applicationDidBecomeActive:(UIApplication *)application
{
	
}

// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
- (void)applicationWillTerminate:(UIApplication *)application
{
	
}

@end
