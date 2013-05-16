//
//  PWRemoteControlServerManager.m
//  PassagewayServerFramework
//
//  Created by Mark Sinkovics on 3/8/13.
//
//

#import "PWRemoteControlServerManager.h"

@interface PWRemoteControlServerManager ()

@property (nonatomic, strong, readwrite)	PWTCPServer* controlServer;
@property (nonatomic, strong, readwrite)	PWTCPServer* screenSharingServer;
@property (nonatomic, strong, readwrite)	NSMutableArray*	authenticatedPeers;
@end

@implementation PWRemoteControlServerManager

@synthesize controlServer			= _controlServer;
@synthesize screenSharingServer		= _screenSharingServer;
@synthesize delegate				= _delegate;
@synthesize imageScale				= _imageScale;

#pragma mark - Instance Methods

- (id)init
{
    self = [super init];
	
    if (self)
	{
		[self _createControlServer];
		
		[self _createScreenSharingServer];
		
		self.imageScale = 1.0;
		
		self.authenticatedPeers = [NSMutableArray array];
    }
	
    return self;
}

- (void)_createControlServer
{
	self.controlServer = [[[PWTCPServer alloc] initWithDomain:@"local."
														 type:@"_passagewayservice._tcp"
														 name:@"ScreenSharingService"] autorelease];
	
	[self.controlServer setEnableBonjour:YES];
	
	[self.controlServer.delegate addDelegate:self];
}

- (void)_createScreenSharingServer
{
	self.screenSharingServer = [[[PWTCPServer alloc] initWithDomain:@"local."
															   type:@"_passagewayservice_screen_sharing._tcp"
															   name:@"ScreenSharingService ScreenSharing"] autorelease];
	
	[self.screenSharingServer.delegate addDelegate:self];

}

#pragma mark - Memory Management

- (void)dealloc
{
	self.authenticatedPeers = nil;
	
	self.controlServer = nil;
	
	self.screenSharingServer = nil;
    
    [super dealloc];
}

#pragma mark - Public Methods

- (void)start
{
	if(![self.controlServer isActive])
	{
		[self.controlServer start];
		
		[self.screenSharingServer start];		
	}
}

- (void)stop
{
	if ([self.controlServer isActive])
	{
		[self.controlServer stopByUser];
		
		[self.authenticatedPeers removeAllObjects];
	}
	
	if ([self.screenSharingServer isActive])
	{
		[self.screenSharingServer stopByUser];
	}
}

#pragma mark - Status Methods

- (BOOL)active
{
	return [self.controlServer isActive];
}

- (void)changeBonjourName:(NSString*)name
{
	self.controlServer.bonjourName = name;
}

- (void)sendSreenImage
{
	NSUInteger numberOfData = 0;
	
	if (self.delegate)
	{
		if ([self.delegate respondsToSelector:@selector(numberOfDataForScreenSharingForManager:)]
			&& [self.delegate respondsToSelector:@selector(manager:dataForScreenSharingAtIndex:)])
		{
			numberOfData = [self.delegate numberOfDataForScreenSharingForManager:self];
		}
	}
	
	dispatch_apply(numberOfData, _private_serial_queue, ^(size_t i) {
		
		NSData* data = [self.delegate manager:self dataForScreenSharingAtIndex:i];
		
		if (data)
		{
			[self.screenSharingServer broadcastData:data];
		}
		
	});
}

#pragma mark - Authentication

- (BOOL)_validateAccesRequest:(PWMsgAccessRequest*)accesRequest
{
	BOOL result = NO;
	
	if ([accesRequest isKindOfClass:[PWMsgAccessRequest class]])
	{
		if ([self.delegate respondsToSelector:@selector(manager:validateUsername:withPassword:)])
		{
			result = [self.delegate manager:self validateUsername:accesRequest.username withPassword:accesRequest.password];
		}
	}
	
	return result;
}

#pragma mark - Private Methods

- (BOOL)_isAuthenticatedPeer:(PWBasePeer*)peer
{
	return ([self.authenticatedPeers containsObject:peer.uuid]);
}

- (void)_storeAccessRequest:(PWMsgAccessRequest*)accessRequest toPeer:(PWBasePeer*)peer 
{
	[_authenticatedPeers addObject:peer.uuid];
}

- (void)_startScreenSharingServer
{
	if (self.screenSharingServer.peers.count == 1)
	{
		if ([self.delegate respondsToSelector:@selector(startScreenSharingForManager:)])
		{
			[self.delegate startScreenSharingForManager:self];
		}
	}
}

- (void)_stopScreenSharingServer
{
	NSLog(@"self.screenSharingServer.peers.count %ld", (unsigned long)self.screenSharingServer.peers.count);
	
	if (self.screenSharingServer.peers.count == 0)
	{
		if ([self.delegate respondsToSelector:@selector(stopScreenSharingForManager:)])
		{
			[self.delegate stopScreenSharingForManager:self];
		}
	}
}

- (void)_fillServerPropertiesInControlResponse:(PWMsgControlResponse*)controlResponse
{
	controlResponse.hostIPv4 = [self.screenSharingServer hostIPv4];
	
	controlResponse.portIPv4 = @(self.screenSharingServer.port);
	
	controlResponse.hostIPv6 = [self.screenSharingServer hostIPv6];
	
	controlResponse.portIPv6 = @(self.screenSharingServer.port);
}

- (void)_fillImagePropertiesInControlResponse:(PWMsgControlResponse*)controlResponse
{
	int numTileHorizontal = 0;
	
	int numTileVertical = 0;
	
	float tileWidth  = 0.0;
	
	float tileHeight  = 0.0;
	
	if (self.delegate)
	{
		if ([self.delegate respondsToSelector:@selector(manager:numTileHotizontal:numTileVertical:tileWidth:tileHeight:)])
		{     
			[self.delegate manager:self
				 numTileHotizontal:&numTileHorizontal
				   numTileVertical:&numTileVertical
						 tileWidth:&tileWidth
						tileHeight:&tileHeight];
		}
	}
	
	controlResponse.numH = @(numTileHorizontal);
	
	controlResponse.numV = @(numTileVertical);
	
	controlResponse.sizeV = @(tileHeight);
	
	controlResponse.sizeH = @(tileWidth);
	
	controlResponse.scale = @(self.imageScale);
}

/*	Send a receive msg to peer
	If the authentication was successful send the udp serves's hosts and ports
 */
- (void)_receiveToPeer:(PWBasePeer*)peer withSuccessfulAccess:(BOOL)success
{
	PWMsgAccessResponse* accessResponse = [[PWMsgAccessResponse alloc] init];
	
	accessResponse.accepted = @(success);
	
	NSData* msg = [[MSJSONMapperManager sharedManager] unmapObject:accessResponse];
	
	[accessResponse release];
	
	[peer sendData:msg];
}

- (void)_response:(PWMsgControlResponse*)controlResponse toScreenSharingControlRequest:(PWMsgControlRequest*)controlRequest fromPeer:(PWBasePeer*)peer
{
	controlResponse.screenSharingEnabled = @(NO);
	
	if (controlRequest.enableScreenSharing.boolValue)
	{
		if (self.delegate)
		{
			if ([self.delegate respondsToSelector:@selector(shouldScreenSharingForManager:)])
			{
				if ([self.delegate shouldScreenSharingForManager:self])
				{
					controlResponse.screenSharingEnabled = @(YES);
					
					__flag.screenSharing = YES;
					
					[self _fillImagePropertiesInControlResponse:controlResponse];
					
					[self _fillServerPropertiesInControlResponse:controlResponse];
				}
			}
		}
	}
	else
	{
		__flag.screenSharing = NO;
		
		if ([self.delegate respondsToSelector:@selector(stopScreenSharingForManager:)])
		{
			[self.delegate stopScreenSharingForManager:self];
		}
	}
}

- (void)_response:(PWMsgControlResponse*)controlResponse toRemoteDeviceControlRequest:(PWMsgControlRequest*)controlRequest fromPeer:(PWBasePeer*)peer
{
	controlResponse.remoteDeviceEnabled = @(NO);

	if (controlRequest.enableRemoteDevice.boolValue)
	{
		if (self.delegate)
		{
			if ([self.delegate respondsToSelector:@selector(shouldRemoteDeviceForManager:)])
			{
				if ([self.delegate shouldRemoteDeviceForManager:self])
				{
					controlResponse.remoteDeviceEnabled = @(YES);
					
					__flag.remoteDevice = YES;
					
					[self _fillServerPropertiesInControlResponse:controlResponse];
				}
			}
		}
	}
	else
	{
		__flag.remoteDevice = NO;
		
//		if ([self.delegate respondsToSelector:@selector(stopScreenSharingForManager:)])
//		{
//			[self.delegate stopScreenSharingForManager:self];
//		}
	}
}

- (void)_handleControlRequest:(PWMsgControlRequest*)controlRequest fromPeer:(PWBasePeer*)peer
{
	PWMsgControlResponse* controlResponse = [[PWMsgControlResponse alloc] init];;
	
	if(controlRequest.enableScreenSharing)
	{
		[self _response:controlResponse toScreenSharingControlRequest:controlRequest fromPeer:peer];
	}
	
	if(controlRequest.enableRemoteDevice)
	{
		[self _response:controlResponse toRemoteDeviceControlRequest:controlRequest fromPeer:peer];
	}
	
	if (controlResponse)
	{
		NSData* controlResponseJSONData = [[MSJSONMapperManager sharedManager] unmapObject:controlResponse];
		
		[peer sendData:controlResponseJSONData];
	}
	
	[controlResponse release];
}

- (void)_handleRemoteDeviceData:(NSData*)remoteDeviceData fromPeer:(PWBasePeer*)peer
{
	if (self.delegate)
	{
		if ([self.delegate respondsToSelector:@selector(manager:didReceiveRemoteDeviceData:byRemoteDeviceType:)])
		{
			unsigned char type;
			
			[remoteDeviceData getBytes:&type length:sizeof(unsigned char)];
			
			[self.delegate manager:self
		didReceiveRemoteDeviceData:[remoteDeviceData subdataWithRange:NSMakeRange(sizeof(unsigned char), remoteDeviceData.length - sizeof(unsigned char))]
				 byRemoteDeviceType:type];
		}
	}
}

#pragma mark - PWBaseServerDelegate Methods

- (void)server:(PWBaseServer*)server didStartWithInfo:(NSString*)info
{
	NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)server:(PWBaseServer*)server didStopWithReason:(NSError*)error
{
	NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)server:(PWBaseServer*)server didConnectToPeer:(PWBasePeer*)peer
{
	if (server == self.controlServer)
	{
		NSLog(@"Peer(%@) connected to server %s", peer, __PRETTY_FUNCTION__);
	}
	else if (server == self.screenSharingServer)
	{
		NSLog(@"screenSharingServer %s Peer(%@) ", __PRETTY_FUNCTION__, peer);
		
		if (__flag.screenSharing)
		{
			[self _startScreenSharingServer];
		}		
	}
}

- (void)server:(PWBaseServer*)server didDisconnectFromPeer:(PWBasePeer*)peer
{
	if (server == self.controlServer)
	{
		NSLog(@"controlServer %s", __PRETTY_FUNCTION__);
	}
	else if (server == self.screenSharingServer)
	{
		NSLog(@"screenSharingServer %s", __PRETTY_FUNCTION__);
		
		[self _stopScreenSharingServer];
		
		__flag.screenSharing = NO;
		
		__flag.remoteDevice = NO;
	}
}

- (void)server:(PWBaseServer*)server didReceiveData:(NSData*)data fromPeer:(PWBasePeer*)peer
{
	if (server == self.controlServer)
	{
		if ([self _isAuthenticatedPeer:peer])
		{
			PWMsgControlRequest* controlRequest = [[MSJSONMapperManager sharedManager] mapJSONData:data];
			
			[self _handleControlRequest:controlRequest fromPeer:peer];
		}
		else
		{
			PWMsgAccessRequest* accessRequest = [[MSJSONMapperManager sharedManager] mapJSONData:data];

			if ([self _validateAccesRequest:accessRequest])
			{
				[self _storeAccessRequest:accessRequest toPeer:peer];
				
				[self _receiveToPeer:peer withSuccessfulAccess:YES];
			}
			else
			{
				[self _receiveToPeer:peer withSuccessfulAccess:NO];
			}
		}
 	}
	else if (server == self.screenSharingServer)
	{
		[self _handleRemoteDeviceData:data fromPeer:peer];
	}
}

- (void)server:(PWBaseServer*)server didUpdatePeerList:(NSArray*)peerList
{
	NSLog(@"%s", __PRETTY_FUNCTION__);
}

@end
