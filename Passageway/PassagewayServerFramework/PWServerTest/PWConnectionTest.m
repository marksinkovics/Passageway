//
//  PWConnectionTest.m
//  PassagewayServerFramework
//
//  Created by Mark Sinkovics on 3/13/13.
//
//

#import "PWConnectionTest.h"

@implementation PWConnectionTest

- (void)setUp
{
	[super setUp];
	
	_hasConnected = NO;
	
	_receivedAccessResponse = NO;
	
	_receivedScreenSharingData = NO;
	
	_screenSharingDataCounter = 0;
	
	_loginCounter = 0;

    _serverManager = [[PWRemoteControlServerManager alloc] init];
    
	_serverManager.delegate = self;
	
	[_serverManager start];
	
	_clientManager = [[PWRemoteControlClientManager alloc] init];
	
	_clientManager.delegate = self;
	
	[_clientManager start];
}

- (void)tearDown
{
	[super tearDown];
	
	[_serverManager stop];
	
	[_serverManager release], _serverManager = nil;
	
	[_clientManager stop];
	
	[_clientManager release], _clientManager = nil;
}

#pragma mark - PWBaseServerDelegate Methods

- (void)testConnection
{
	STAssertNotNil(_clientManager.browseServer, @"browseServer shouldn't be nil");
	
	STAssertTrue([_clientManager.browseServer isActive], @"browseServer should be active");
	
	STAssertNotNil(_serverManager.controlServer, @"controlServer shouldn't be nil");
	
	STAssertTrue([_serverManager.controlServer isActive], @"controlServer should be active");
		
	NSLog(@"TCP server is exist");	
	
	while (!_hasConnected)
	{
		[[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
	}
	
	NSLog(@"----Peer has connected");
	
	while (!_receivedAccessResponse)
	{
		[[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
	}
	
	NSLog(@"----Response has been received");
	
	while (!_receivedScreenSharingData)
	{
		[[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
	}
	
	NSLog(@"----Screen sharing data has been received");
	
	while (!_receivedMouseData)
	{
		[[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
	}

	NSLog(@"----Mouse data has been received");
	
	while (!_receivedKeyboardData)
	{
		[[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
	}
	
	NSLog(@"----Keyboard data has been received");
	
}

#pragma mark - PWRemoteControlServerManagerDelegate Methods

- (void)manager:(PWRemoteControlServerManager*)manager numTileHotizontal:(int*)horizontal numTileVertical:(int*)vertical tileWidth:(float*)width tileHeight:(float*)height
{
	
}

- (void)startScreenSharingForManager:(PWRemoteControlServerManager *)manager
{
    [manager sendSreenImage];
}

- (void)stopScreenSharingForManager:(PWRemoteControlServerManager *)manager
{
    
}

- (BOOL)shouldScreenSharingForManager:(PWRemoteControlServerManager *)manager
{
    return YES;
}

- (NSInteger)numberOfDataForScreenSharingForManager:(PWRemoteControlServerManager*)manager
{
	return 50;
}

- (NSData*)manager:(PWRemoteControlServerManager*)manager dataForScreenSharingAtIndex:(NSInteger)index
{
	return [@"Hello World!!!" dataUsingEncoding:NSUTF8StringEncoding];
}

- (BOOL)manager:(PWRemoteControlServerManager *)manager validateUsername:(NSString *)username withPassword:(NSString *)password
{
	return ([username isEqualToString:@"test"] && [password isEqualToString:@"ester"]);
}

- (BOOL)shouldRemoteDeviceForManager:(PWRemoteControlServerManager*)manager;
{
	return YES;
}

//- (void)manager:(PWRemoteControlServerManager *)manager didReceiveRemoteDeviceData:(NSData *)data byRemoteDeviceTye:(PWCommunicationRemoteDeviceType)deviceType

- (void)manager:(PWRemoteControlServerManager *)manager didReceiveRemoteDeviceData:(NSData *)data byRemoteDeviceType:(PWCommunicationRemoteDeviceType)deviceType
{
	if (deviceType == PWCommunicationRemoteDeviceTypeMouse)
	{
		NSString* str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		
		NSLog(@"---(%d)--- Mouse data: %@", deviceType, str);
		
		[str release];
		
		_receivedMouseData = YES;
	}
	else if (deviceType == PWCommunicationRemoteDeviceTypeKeyboard)
	{
		NSString* str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		
		NSLog(@"---(%d)--- Keyboard data: %@", deviceType, str);
		
		[str release];
		
		_receivedKeyboardData = YES;
	}
}

#pragma mark - PWRemoteControlClientManagerDelegate

- (void)manager:(PWRemoteControlClientManager*)manager didConnectToControlServer:(PWTCPPeer*)tcpPeer
{
	NSLog(@"Client connected to the server");
	
	_hasConnected = YES;
	
	[manager sendAccessRequest];
}

- (void)manager:(PWRemoteControlClientManager*)manager accessGrantedWithResponse:(PWMsgAccessResponse*)accessResponse
{
	_receivedAccessResponse = YES;
	
	NSLog(@"--- access: %d, %s", _loginCounter, __PRETTY_FUNCTION__);
	
	[manager enableScreenSharing:YES remoteDevice:YES];
}

- (void)manager:(PWRemoteControlClientManager*)manager accessDeniedWithResponse:(PWMsgAccessResponse*)accessResponse
{
	_loginCounter++;
	
	NSLog(@"--- denied: %d, %s", _loginCounter, __PRETTY_FUNCTION__);
	
	[manager sendAccessRequest];
	
//	_receivedAccessResponse = YES;
//	
//	_receivedUDPData = YES;
}

- (void)manager:(PWRemoteControlClientManager*)manager didReceiveScreenSharingData:(NSData*)data
{
	NSString* str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	
	NSLog(@"----(%d)STR %@", _screenSharingDataCounter, str);
	
	if((_screenSharingDataCounter++) == 49)
	{
		[manager enableScreenSharing:NO remoteDevice:YES];
		
		_receivedScreenSharingData = YES;
	}
}

- (void)manager:(PWRemoteControlClientManager *)manager didEnableScreenSharing:(NSNumber*)enabled;
{
	NSLog(@"did enable screen sharing");
}

- (void)manager:(PWRemoteControlClientManager *)manager didFindPeers:(NSArray *)peers
{
	if (peers.count > 0)
	{
		PWTCPPeer* peer = [peers objectAtIndex:0];
		
		[manager connectToPeer:peer];
	}
}

- (NSString*)usernameForManager:(PWRemoteControlClientManager *)manager
{
	return  _loginCounter == 1 ? @"test" : @"hamis";
}

- (NSString*)manager:(PWRemoteControlClientManager *)manager passwordForUsername:(NSString*)username
{
	return  _loginCounter == 1 ? @"ester" : @"";
}

- (void)manager:(PWRemoteControlClientManager*)manager didEnableScreenSharing:(NSNumber *)screenSharingEnabled didEnableRemoteDevice:(NSNumber *)remoteDeviceEnabled
{
	NSLog(@"did enable remote devices");
	
	[manager sendMouseData];
	
	[manager sendKeyboardData];

}

- (NSData*)remoteDeviceDataForDeviceType:(PWCommunicationRemoteDeviceType)deviceType toManager:(PWRemoteControlClientManager *)manager
{
	if (deviceType == PWCommunicationRemoteDeviceTypeKeyboard)
	{
		return [@"Example keyboard data" dataUsingEncoding:NSUTF8StringEncoding];
	}
	else if (deviceType == PWCommunicationRemoteDeviceTypeMouse)
	{
		return [@"Example mouse data" dataUsingEncoding:NSUTF8StringEncoding];			
	}
	
	return nil;
}


@end
