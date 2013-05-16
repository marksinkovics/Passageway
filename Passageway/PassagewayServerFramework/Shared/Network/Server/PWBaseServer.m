	//
//  PWBaseServer.m
//  PassagewayServerFramework
//
//  Created by Mark Sinkovics on 1/11/13.
//
//

#import "PWBaseServer.h"

@interface PWBaseServer ()

@property (nonatomic, strong, readwrite) PWDelegateController* delegate;

@property (nonatomic, copy, readwrite) NSString* bonjourDomain;
@property (nonatomic, copy, readwrite) NSString* bonjourType;

@property (nonatomic, strong, readwrite) NSMutableArray* peers;

@end

@implementation PWBaseServer

@synthesize delegate = _delegate;

@synthesize bonjourDomain = _bonjourDomain;
@synthesize bonjourType = _bonjourType;
@synthesize bonjourName = _bonjourName;
@synthesize peers = _peers;

#pragma mark - Server Create Methods

- (id)init
{
	return [self initWithDomain:@"" type:@"" name:@""];
}

- (id)initWithDomain:(NSString*)domain type:(NSString *)type name:(NSString *)name
{
	self = [super init];
	
	if (self)
	{
		self.bonjourDomain = domain;
		self.bonjourType = type;
		self.bonjourName = name;
		
		//TODO: Have to change the input protocol to valid.
		self.delegate = [PWDelegateController delegateWithProtocol:@protocol(PWBaseServerDelegate)];
		
		self.peers = [NSMutableArray array];		

		__base_flag.active = NO;
	}
	
	return self;
}

#pragma mark - Memory Management

- (void)dealloc
{
	self.peers = nil;
	
	self.delegate = nil;

	self.bonjourDomain = nil;
    
	self.bonjourType = nil;
    
	self.bonjourName = nil;
	
    [super dealloc];
}

#pragma mark - Private Methods

- (void)testPeersConnection
{
	NSLog(@"%s", __PRETTY_FUNCTION__);
	
	[self.peers makeObjectsPerformSelector:@selector(testConnection)];
}


#pragma mark - Server Control Methods

- (void)start
{
	__base_flag.active = YES;
}

- (void)stopByUser
{
	[self stopWitReason:[NSError errorWithDomain:@"User" code:-1 userInfo:nil]];
}

- (void)stopWitReason:(NSError *)error
{
	[self connectionTestingEnable:NO];
	
	__base_flag.active = NO;
	
	for (PWBasePeer* peer in self.peers)
	{
		[peer disconnect];
	}
	
	[self.peers removeAllObjects];
	
	[self.delegate invokeSelector:@selector(server:didStopWithReason:) withParameters:@[self, error?error:[NSNull null]]];	
}

- (void)removePeer:(PWBasePeer*)peer
{
	[self.peers removeObject:peer];
}

#pragma mark - Status Methods

- (BOOL)isActive
{
	return __base_flag.active;
}

- (void)connectionTestingEnable:(BOOL)enable
{
	__base_flag.enableConnectionTest = enable;
	
	if (__base_flag.enableConnectionTest)
	{
		_timer = [[NSTimer scheduledTimerWithTimeInterval:5.0
												   target:self
												 selector:@selector(testPeersConnection)
												 userInfo:nil
												  repeats:YES] retain];
	}
	else
	{
		[_timer invalidate];
		
		[_timer release], _timer = nil;
	}
}

#pragma mark - Connect/Disconnect

- (NSArray*)connectedPeers
{
	NSPredicate* connectedPredicate = [NSPredicate predicateWithFormat:@"SELF.connected == YES"];
	
	NSArray* filteredPeers = [self.peers filteredArrayUsingPredicate:connectedPredicate];
	
	return filteredPeers;
}

- (void)connectToPeers:(NSArray*)peers
{
	[peers makeObjectsPerformSelector:@selector(connect)];
}

- (void)disconnectFromPeers:(NSArray*)peers
{
	[peers makeObjectsPerformSelector:@selector(disconnect)];
}

#pragma mark - Data Sending Methods

- (void)unicastData:(NSData*)data toPeer:(PWBasePeer*)peer
{
	[peer sendData:data];
}

- (void)multicastData:(NSData*)data toPeers:(NSArray*)peer
{
	[peer makeObjectsPerformSelector:@selector(sendData:) withObject:data];
}

- (void)broadcastData:(NSData*)data
{
	[self.peers makeObjectsPerformSelector:@selector(sendData:) withObject:data];
}

#pragma mark - PWPeer Delegate Method

//FIXME: find a better way to keep alive peer object while send a msg to instances
- (void)peer:(PWBasePeer*)peer failedWithError:(NSError*)error
{
	PWBasePeer* _tempPeer = [peer retain];
	
	[self removePeer:peer];
	
	[self.delegate invokeSelector:@selector(server:didDisconnectFromPeer:) withParameters:@[self, _tempPeer]];
	
	[_tempPeer release];
}

- (void)didConnectPeer:(PWBasePeer*)peer
{
	[self.delegate invokeSelector:@selector(server:didConnectToPeer:) withParameters:@[self, peer]];
}

- (void)didDisconnectedPeer:(PWBasePeer*)peer
{
	[self removePeer:peer];
	
	[self.delegate invokeSelector:@selector(server:didDisconnectFromPeer:) withParameters:@[self, peer]];
}

- (void)peer:(PWBasePeer*)peer didReceiveData:(NSData*)data
{
	[self.delegate invokeSelector:@selector(server:didReceiveData:fromPeer:) withParameters:@[self, data, peer]];
}

- (void)peer:(PWBasePeer*)peer didWriteData:(NSData*)data
{
	
}


@end
