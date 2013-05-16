//
//  PWTCPTest.m
//  PassagewayServerFramework
//
//  Created by Mark Sinkovics on 3/30/13.
//
//

#import "PWTCPTest.h"

#define MAX_MSG_SERVER 5
#define MAX_MSG_CLIENT 5

@interface PWTCPTest ()

@property (nonatomic, strong) PWTCPServer* server;
@property (nonatomic, strong) PWTCPPeer* client;

@end

@implementation PWTCPTest

@synthesize server = _server;
@synthesize client = _client;

- (void)setUp
{
	[super setUp];
	
	_didStartServer = NO;
	_didConnectClientAtServerSide = NO;
	_didConnectClientAtClientSide = NO;
	_didReceiveDataAtServerSide = NO;
	_didReceiveDataAtClientSide = NO;
	
	_receivedDataCounterAtServerSide = 0;
}

- (void)tearDown
{
	self.server = nil;	
	self.client = nil;
	
	[super tearDown];
}

#pragma mark - Test Cases

- (void)testConnection
{
	self.server = [[[PWTCPServer alloc] initWithDomain:@"" type:@"" name:@""] autorelease];
	
	[self.server.delegate addDelegate:self];
	
	[self.server start];
	
	NSLog(@"--- ALLOCATED server");
	
	while (!_didStartServer)
	{
		[[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
	}
	
	NSLog(@"--- STARTED server %@:%d", [self.server hostIPv4], [self.server port]);
	
	self.client = [[PWTCPPeer alloc] init];
	
	self.client.delegate = self;
				   
	[self.client connectToHost:@"localhost" port:[self.server port]];
	
	NSLog(@"--- ALLOCATED client");
	
	while (!_didConnectClientAtServerSide && !_didConnectClientAtServerSide)
	{
		[[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
	}
	
	NSLog(@"--- CONNECTED client");
		
	while (!_didReceiveDataAtServerSide)
	{
		[[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
	}
		
	NSLog(@"--- DATA RECEIVED server");
	
	while (!_didReceiveDataAtClientSide)
	{
		[[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
	}
	
	NSLog(@"--- DATA RECEIVED client");
}

#pragma mark - PWBaseServerDelegate

- (void)server:(PWBaseServer*)server didStartWithInfo:(NSString*)info
{
	_didStartServer = YES;
}

- (void)server:(PWBaseServer*)server didStopWithReason:(NSError*)error
{
	NSLog(@"%s | %@", __PRETTY_FUNCTION__, error);
}

- (void)server:(PWBaseServer*)server didConnectToPeer:(PWBasePeer*)peer
{
	NSLog(@"%s", __PRETTY_FUNCTION__);
	
	_didConnectClientAtServerSide = YES;
	
	for (int i = 0; i < MAX_MSG_SERVER; i++)
	{
		[self.client sendData:[@"Client" dataUsingEncoding:NSUTF8StringEncoding]];
	}
}

- (void)server:(PWBaseServer*)server didDisconnectFromPeer:(PWBasePeer*)peer
{
	
}

- (void)server:(PWBaseServer*)server didReceiveData:(NSData*)data fromPeer:(PWBasePeer*)peer
{
	NSString* msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	
	NSLog(@"msg: %@", msg);	
	
	STAssertTrue([@"Client" isEqualToString:msg], @"Msg (%@) should be 'Client'", msg);
	
	[msg release];
	
	_receivedDataCounterAtServerSide ++ ;
	
	if (_receivedDataCounterAtServerSide == MAX_MSG_SERVER)
	{
		_didReceiveDataAtServerSide = YES;
		
		for(int i = 0; i < MAX_MSG_CLIENT; i++)
		{
			if (i == 0)
			{
				[peer sendData:[NSMutableData dataWithLength:(1024*1024)]];
			}
			else
			{
				[peer sendData:[@"Server" dataUsingEncoding:NSUTF8StringEncoding]];
			}			
		}
	}
}

- (void)server:(PWBaseServer*)server didUpdatePeerList:(NSArray*)peerList
{
	
}

#pragma mark - PWBasePeerDelegate

- (void)peer:(PWBasePeer*)peer failedWithError:(NSError*)error
{
	NSLog(@"%s | %@", __PRETTY_FUNCTION__, error);
}

- (void)didConnectPeer:(PWBasePeer*)peer
{
	NSLog(@"%s", __PRETTY_FUNCTION__);
	
	_didConnectClientAtClientSide = YES;
}

- (void)didDisconnectedPeer:(PWBasePeer*)peer
{
	
}

- (void)peer:(PWBasePeer*)peer didReceiveData:(NSData*)data
{
	NSString* msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

	NSLog(@"data.length: %lu", data.length);
	
	NSLog(@"msg: %@", msg);
	
//	STAssertTrue([@"Server" isEqualToString:msg], @"Msg (%@) should be 'Server'", msg);
	
	[msg release];
	
	_receivedDataCounterAtClientSide++;
	
	if (_receivedDataCounterAtClientSide == MAX_MSG_CLIENT)
	{
		_didReceiveDataAtClientSide = YES;
	}
}

- (void)peer:(PWBasePeer*)peer didWriteData:(NSData*)data
{
	NSLog(@"%s", __PRETTY_FUNCTION__);
}


@end
