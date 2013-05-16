//
//  PWRemoteControlClientManager.m
//  PassagewayServerFramework
//
//  Created by Mark Sinkovics on 3/13/13.
//
//

#import "PWRemoteControlClientManager.h"
#import "NSString+Utilities.h"

@interface PWRemoteControlClientManager ()

@property (nonatomic, strong, readwrite) PWBrowseServer* browseServer;
@property (nonatomic, strong, readwrite) PWTCPPeer* controlPeer;
@property (nonatomic, strong, readwrite) PWTCPPeer* screenSharingPeer;
@property (nonatomic, strong, readwrite) PWMsgAccessResponse* accessResponse;

@end

@implementation PWRemoteControlClientManager

@synthesize browseServer		= _browseServer;
@synthesize controlPeer			= _controlPeer;
@synthesize screenSharingPeer	= _screenSharingPeer;
@synthesize delegate			= _delegate;
@synthesize accessResponse		= _accessResponse;

#pragma mark - Class Methods

+ (id)manager
{
	PWRemoteControlClientManager* cm = [[PWRemoteControlClientManager alloc] init];
	
	return [cm autorelease];
}

#pragma mark - Instance Methods

- (id)init
{
    self = [super init];
	
    if (self)
	{
		
    }
    return self;
}

- (void)dealloc
{
	NSLog(@"%s", __PRETTY_FUNCTION__);
	
	[self stop];
	
	NSLog(@"self.controlPeer %ld %@", (unsigned long)[self.controlPeer retainCount], self.controlPeer);
	NSLog(@"self.screenSharingPeer %ld %@", (unsigned long)[self.screenSharingPeer retainCount], self.screenSharingPeer);
	
	self.delegate = nil;	
	
    [super dealloc];
}

- (void)start
{
	NSLog(@"%s %ld", __PRETTY_FUNCTION__, (unsigned long)[self retainCount]);
	
	if (self.browseServer == nil)
	{
		self.browseServer = [[[PWBrowseServer alloc] initWithDomain:@"local."
															   type:@"_passagewayservice._tcp"
															   name:@"Client"] autorelease];
		[self.browseServer.delegate addDelegate:self];
		
		[self.browseServer start];
	}
}

- (void)stop
{	
	NSLog(@"%s %ld", __PRETTY_FUNCTION__, (unsigned long)[self retainCount]);
	
	[self _disconnectPeers];
	
	if (self.browseServer)
	{
		if ([self.browseServer isActive])
		{
			[self.browseServer stopByUser];
		}

		
		self.browseServer = nil;
	}
}

- (BOOL)active
{
	return [self.browseServer isActive];
}

- (void)enableScreenSharing:(BOOL)enableScreenSharing remoteDevice:(BOOL)enableRemoteDevice
{
	[self _doEnableScreenSharing:enableScreenSharing remoteDevice:enableRemoteDevice];
}

- (void)connectToPeer:(PWTCPPeer *)peer
{
	self.controlPeer = peer;
	
	self.controlPeer.delegate = self;
	
	[self.controlPeer connect];
}

- (void)sendAccessRequest
{
	PWMsgAccessRequest* accessRequest = [[PWMsgAccessRequest alloc] init];
	
	if ([self.delegate respondsToSelector:@selector(usernameForManager:)])
	{
		accessRequest.username = [self.delegate usernameForManager:self];
	}
	
	if ([self.delegate respondsToSelector:@selector(manager:passwordForUsername:)])
	{
		accessRequest.password = [self.delegate manager:self passwordForUsername:accessRequest.username];
	}
	
	NSData* msg = [[MSJSONMapperManager sharedManager] unmapObject:accessRequest];
	
	[self.controlPeer sendData:msg];
	
	[accessRequest release];
}

- (void)_sendDataOfRemoteDeviceType:(PWCommunicationRemoteDeviceType)remoteDeviceType
{
	NSData* data = nil;
	
	if ([self.delegate respondsToSelector:@selector(remoteDeviceDataForDeviceType:toManager:)])
	{
		data = [self.delegate remoteDeviceDataForDeviceType:remoteDeviceType toManager:self];
	}

	if (data)
	{
		unsigned char type = remoteDeviceType;
		
		NSMutableData* remoteDeviceData = [NSMutableData dataWithBytes:&type length:sizeof(unsigned char)];
		
		[remoteDeviceData appendData:data];
		
		[self.screenSharingPeer sendData:remoteDeviceData];
	}
}

- (void)sendMouseData
{
	[self _sendDataOfRemoteDeviceType:PWCommunicationRemoteDeviceTypeMouse];
}

- (void)sendKeyboardData
{
	[self _sendDataOfRemoteDeviceType:PWCommunicationRemoteDeviceTypeKeyboard];
}

#pragma mark - Private Methods

-(void)_doEnableScreenSharing:(BOOL)enableScreenSharing remoteDevice:(BOOL)enableRemoteDevice
{
	if (enableScreenSharing || enableRemoteDevice)
	{
		PWMsgControlRequest* controlRequest = [[PWMsgControlRequest alloc] init];
		
		if (enableScreenSharing != __flag.enabledScreenSharing)
		{
			controlRequest.enableScreenSharing = @(enableScreenSharing);
		}
		
		if (enableRemoteDevice != __flag.enableRemoteDevice)
		{
			controlRequest.enableRemoteDevice = @(enableRemoteDevice);
		}
		
		NSData* msg = [[MSJSONMapperManager sharedManager] unmapObject:controlRequest];
		
		[self.controlPeer sendData:msg];
		
		[controlRequest release];
		
	}
	else if (!enableScreenSharing && !enableRemoteDevice)
	{
		[self.screenSharingPeer disconnect];
		
		self.screenSharingPeer = nil;
	}
	
	__flag.enabledScreenSharing = enableScreenSharing;
	
	__flag.enableRemoteDevice = enableRemoteDevice;
}

- (void)_handleControlResponse:(PWMsgControlResponse*)controlResponse
{
    if (controlResponse.screenSharingEnabled)
    {
		if ([self.delegate respondsToSelector:@selector(manager:didReceiveScreenSharingResponse:)])
		{
			[self.delegate manager:self didReceiveScreenSharingResponse:controlResponse];
		}
		
    }
	
	if (controlResponse.remoteDeviceEnabled)
    {
		
    }
	
	if (self.screenSharingPeer == nil)
	{
		if (controlResponse.hostIPv4 && controlResponse.portIPv4)
		{
			self.screenSharingPeer = [[[PWTCPPeer alloc] init] autorelease];
			
			self.screenSharingPeer.delegate = self;
			
			[self.screenSharingPeer connectToHost:controlResponse.hostIPv4 port:controlResponse.portIPv4.unsignedShortValue];
		}
		else
		{
			NSLog(@"missing server data");
		}
	}
	else
	{
		[self _hasConnectedScreenSharingPeer];
	}

}

#pragma mark - PWBaseServerDelegate / PWBrowseServer Methods

- (void)server:(PWBaseServer*)server didUpdatePeerList:(NSArray*)peerList
{
	if ([self.delegate respondsToSelector:@selector(manager:didFindPeers:)])
	{
		[self.delegate manager:self didFindPeers:peerList];
	}
}

#pragma mark - PWBasePeerDelegate Methods

- (void)_hasConnectedControlPeer
{
	if ([self.delegate respondsToSelector:@selector(manager:didConnectToControlServer:)])
	{
		[self.delegate manager:self didConnectToControlServer:self.controlPeer];
	}
}

- (void)_hasConnectedScreenSharingPeer
{
	if ([self.delegate respondsToSelector:@selector(manager:didEnableScreenSharing:didEnableRemoteDevice:)])
	{
		[self.delegate manager:self didEnableScreenSharing:@(__flag.enabledScreenSharing) didEnableRemoteDevice:@(__flag.enableRemoteDevice)];
	}
}

- (void)_disconnectPeers
{
	NSLog(@"%s", __PRETTY_FUNCTION__);
	
	[self.screenSharingPeer disconnect];
	
	self.screenSharingPeer = nil;
	
	[self.controlPeer disconnect];
	
	self.controlPeer = nil;
}

#pragma mark - PWBasePeerDelegate Methods

- (void)peer:(PWBasePeer*)peer failedWithError:(NSError*)error
{
	NSLog(@"%s", __PRETTY_FUNCTION__);
	
	if (self.controlPeer == peer)
	{
		self.controlPeer = nil;
	}
	else if(self.screenSharingPeer == peer)
	{
		self.screenSharingPeer = nil;
	}
}

- (void)didConnectPeer:(PWBasePeer*)peer
{
	if (self.controlPeer == peer)
	{
		[self _hasConnectedControlPeer];
	}
	else if(self.screenSharingPeer == peer)
	{
		[self _hasConnectedScreenSharingPeer];
	}
}

- (void)didDisconnectedPeer:(PWBasePeer*)peer
{
	if (self.controlPeer == peer)
	{
		self.controlPeer = nil;
	}
	else if(self.screenSharingPeer == peer)
	{
		self.screenSharingPeer = nil;
	}
}

- (void)peer:(PWBasePeer*)peer didReceiveData:(NSData*)data
{	
	if ([peer isEqual:self.controlPeer])
	{
		NSLog(@"received data: %@", [data stringValue]);
		
		id msg = [[MSJSONMapperManager sharedManager] mapJSONData:data];
		
		if([msg isKindOfClass:[PWMsgAccessResponse class]])
		{
			self.accessResponse = msg;
			
			if (self.accessResponse.accepted.boolValue)
			{
				if ([self.delegate respondsToSelector:@selector(manager:accessGrantedWithResponse:)])
				{
					[self.delegate manager:self accessGrantedWithResponse:self.accessResponse];
				}
			}
			else
			{
				if ([self.delegate respondsToSelector:@selector(manager:accessDeniedWithResponse:)])
				{
					[self.delegate manager:self accessDeniedWithResponse:self.accessResponse];
				}
			}
		}
		else if([msg isKindOfClass:[PWMsgControlResponse class]])
		{
			[self _handleControlResponse:(PWMsgControlResponse*)msg];
		}
	}
	else if(peer == self.screenSharingPeer)
	{
//		dispatch_sync(_private_concurrent_queue, ^{
			
			if (self.delegate)
			{
				if ([self.delegate respondsToSelector:@selector(manager:didReceiveScreenSharingData:)])
				{
					[self.delegate manager:self didReceiveScreenSharingData:data];
				}
			}
			
//		});
	}
}

- (void)peer:(PWBasePeer*)peer didWriteData:(NSData*)data
{
	
}

- (void)peer:(PWBasePeer*)peer updatedStatus:(PWBasePeerStatusType)status
{

}




@end
