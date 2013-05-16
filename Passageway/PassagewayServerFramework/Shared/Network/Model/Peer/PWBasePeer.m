//
//  PWBasePeer.m
//  PassagewayServerFramework
//
//  Created by Mark Sinkovics on 1/28/13.
//
//

#import "PWBasePeer.h"
#import "NSString+Utilities.h"

@interface PWBasePeer ()

@property (nonatomic, strong, readwrite) NSString* uuid;

@end

@implementation PWBasePeer

@synthesize delegate		= _delegate;
@synthesize ipAddress		= _ipAddress;
@synthesize receivedData	= _receivedData;
@synthesize netService		= _netService;
@synthesize uuid			= _uuid;

#pragma mark - Class Methods

//+ (PWBasePeer*)peerWithDelegate:(id<PWBasePeerDelegate>)delegate
//{
//	PWBasePeer *peer = [[self alloc] init];
//	
//	peer.delegate = delegate;
//	
//	return [peer autorelease];
//}
//
//+ (PWBasePeer*)peerWithIPAddress:(PWIPAddress*)ipAddress delegate:(id<PWBasePeerDelegate>)delegate
//{
//	PWBasePeer *peer = [[self alloc] init];
//	
//	peer.ipAddress = [[ipAddress copy] autorelease];
//	
//	peer.delegate = delegate;
//	
//	return [peer autorelease];
//}
//
//+ (PWBasePeer*)peerWithCFSocketNativeHandle:(CFSocketNativeHandle)socketNativeHandle delegate:(id<PWBasePeerDelegate>)delegate
//{
//	PWBasePeer *peer = [[self alloc] init];
//	
//	PWIPAddress* ipAddress = [PWIPAddress ipAddressWithCFSocketNativeHandle:socketNativeHandle];
//	
//	peer.ipAddress = ipAddress;
//	
//	peer.delegate = delegate;
//	
//	return [peer autorelease];
//}
//
//+ (PWBasePeer*)peerWithNetService:(NSNetService*)netService delegate:(id<PWBasePeerDelegate>)delegate
//{
//	PWBasePeer *peer = [[self alloc] init];
//	
//	PWIPAddress* ipAddress = [PWIPAddress ipAddress];
//	
//	peer.ipAddress = ipAddress;
//	
//	peer.netService = netService;
//	
//	peer.delegate = delegate;
//	
//	return [peer autorelease];
//}


#pragma mark - Instance Methods

- (id)init
{
    self = [super init];
	
    if (self)
	{
		self.uuid = [NSString generateUUID];
    }
    return self;
}

- (id)initWithNetService:(NSNetService*)netService
{
    self = [self init];
	
    if (self)
	{
		self.netService = netService;
		
		self.ipAddress = [PWIPAddress ipAddress];
    }
    return self;
}

- (void)dealloc
{
	self.delegate = nil;
	
	self.ipAddress = nil;
	
	self.receivedData = nil;
	
	self.uuid = nil;
	
	NSLog(@"%s", __PRETTY_FUNCTION__);

    [super dealloc];
}

#pragma mark - SETTER

- (void)setNetService:(NSNetService *)netService
{
	if (_netService != netService)
	{
		if (_netService)
		{
			_netService.delegate = nil;
			[_netService removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
			
			[_netService stop];
			
			[_netService release];
			_netService = nil;
		}
		
		if (netService)
		{
			_netService =  [netService retain];
			_netService.delegate = self;
			[_netService scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
		}
	}
}

#pragma mark - Status

- (void)updateStatus:(PWBasePeerStatusType)status andMsg:(NSString *)msg
{
	if (self.delegate)
	{
		switch (status)
		{
			case PWBasePeerStatusTypeError:
			{
				if ([self.delegate respondsToSelector:@selector(peer:failedWithError:)])
				{
					[self.delegate peer:self failedWithError:[NSError errorWithDomain:msg code:-1 userInfo:nil]];
				}
			}
				break;
			case PWBasePeerStatusTypeConnected:
			{
				if ([self.delegate respondsToSelector:@selector(didConnectPeer:)])
				{
					[self.delegate didConnectPeer:self];
				}
			}
				break;
			case PWBasePeerStatusTypeDisconnected:
			{
				if ([self.delegate respondsToSelector:@selector(didDisconnectedPeer:)])
				{
					[self.delegate didDisconnectedPeer:self];
				}

			}
		}
		
	}
}

- (BOOL)connected
{
	return __flag.connected;
}

- (void)connect
{
	if (![self connected])
	{
		[self.netService resolveWithTimeout:5];
	}
}

- (void)disconnect
{
	[self retain];
	
	[self updateStatus:PWBasePeerStatusTypeDisconnected andMsg:@""];
	
	self.delegate = nil;
	
	[self release];
}

- (void)setStatusCode:(unsigned char)status
{
	__flag.status = status;
}

- (void)testConnection
{
	
}


#pragma mark - Description

- (NSString*)name
{
	NSString* retVal = nil;
	
	if (self.netService)
	{
		retVal = self.netService.name;
	}
	else
	{
		if(self.connected)
		{
			retVal = [NSString stringWithFormat:@"%@", self.ipAddress];
		}
		else
		{
			retVal = [super description];
		}
	}
	
	return retVal;
}

- (NSString*)description
{
	NSString* retVal = [NSString stringWithFormat:@"%@ (%@)", [super description], self.connected ? @"CONNECTED" : @"NOT CONNECTED"];
	
	if (self.connected)
	{
		retVal = [NSString stringWithFormat:@"%@, %@", retVal, self.ipAddress];
	}
	
	if (self.netService)
	{
		retVal = [NSString stringWithFormat:@"%@, %@", retVal, self.netService.name];
	}
	
	return retVal;
}

#pragma mark - Data Handling

- (void)sendData:(NSData*)data
{
	
}

#pragma mark - PWBaseBufferDelegate Methods

- (void)didConnectAtBuffer:(PWBaseBuffer *)buffer
{
	if (self.delegate && [self.delegate respondsToSelector:@selector(didConnectPeer:)] && __flag.status == 255)
	{
		__flag.connected = YES;
		
		[self.delegate didConnectPeer:self];
	}
}

- (void)didDisconnectAtBuffer:(PWBaseBuffer *)buffer
{
	if (self.delegate && [self.delegate respondsToSelector:@selector(didDisconnectedPeer:)])
	{
		__flag.connected = NO;
		
		[self.delegate didDisconnectedPeer:self];
	}
}

- (void)buffer:(PWBaseBuffer *)buffer didChangeStatus:(NSNumber *)status
{
	__flag.status = status.unsignedCharValue;
	
	if (__flag.status == 255)
	{
		[self.delegate didConnectPeer:self];
	}
}

- (void)buffer:(PWBaseBuffer*)buffer didWriteData:(NSData*)wroteData
{
	if (self.delegate && [self.delegate respondsToSelector:@selector(peer:didWriteData:)])
	{
		[self.delegate peer:self didWriteData:wroteData];
	}
}

- (void)buffer:(PWBaseBuffer*)buffer didReadData:(NSData*)readData
{
	if (self.delegate && [self.delegate respondsToSelector:@selector(peer:didReceiveData:)])
	{
		[self.delegate peer:self didReceiveData:readData];
	}
}

- (void)buffer:(PWBaseBuffer*)buffer didFailWithError:(NSError*)error
{
	if (self.delegate && [self.delegate respondsToSelector:@selector(peer:failedWithError:)])
	{
		[self.delegate peer:self failedWithError:error];
	}
}

- (void)buffer:(PWBaseBuffer*)buffer updateProgressValue:(NSNumber *)progressValue
{
	
}

@end
