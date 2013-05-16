//
//  PWBrowseServer.m
//  PassagewayServerFramework
//
//  Created by Mark Sinkovics on 1/3/13.
//
//

#import "PWBrowseServer.h"

#import "PWTCPPeer.h"
#import "PWUDPPeer.h"

#import "PWBrowseTCPStrategy.h"
#import "PWBrowseUDPStrategy.h"

@implementation PWBrowseServer

@synthesize netServiceBrowser = _netServiceBrowser;
@synthesize browsingStrategy = _browsingStrategy;

#pragma mark - Memory Management

- (void)dealloc
{
	self.netServiceBrowser.delegate = nil;
	
	[self.netServiceBrowser stop];
	
	self.browsingStrategy = nil;
	
    [super dealloc];
}

#pragma mark - Start

- (void)start
{
	[super start];
	
	if (!self.browsingStrategy)
	{
		self.browsingStrategy = [[[PWBrowseTCPStrategy alloc] init] autorelease];
	}
	
//	NSLog(@"strategy %@/%@/%@", self.browsingStrategy, self.bonjourType, self.bonjourName);
	
	self.netServiceBrowser = [[[NSNetServiceBrowser alloc] init] autorelease];
	
	[self.netServiceBrowser searchForServicesOfType:self.bonjourType
										   inDomain:self.bonjourDomain];
	
	[self.delegate invokeSelector:@selector(server:didStartWithInfo:) withParameters:@[self, @""]];
}

- (void)stopWitReason:(NSError *)error
{
	self.netServiceBrowser.delegate = nil;
	
	[self.netServiceBrowser stop];
	
	self.netServiceBrowser = nil;
	
	self.browsingStrategy = nil;
	
	[super stopWitReason:error];
}

#pragma mark - Overrided Methods

- (void)setNetServiceBrowser:(NSNetServiceBrowser *)netServiceBrowser
{
	if (_netServiceBrowser != netServiceBrowser)
	{
		if (_netServiceBrowser)
		{
			_netServiceBrowser.delegate = nil;
			[_netServiceBrowser removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
			
			[_netServiceBrowser stop];
			[_netServiceBrowser release];
			_netServiceBrowser = nil;
		}
		
		if (netServiceBrowser)
		{
			_netServiceBrowser =  [netServiceBrowser retain];
			_netServiceBrowser.delegate = self;
			[_netServiceBrowser scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
		}
	}
}

#pragma mark - NSNetServiceBrowser Delegate

- (void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser didNotSearch:(NSDictionary *)errorDict
{
	[self stopWitReason:[NSError errorWithDomain:[NSString stringWithFormat:@"%@", [errorDict description]] code:-1 userInfo:nil]];
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)netServiceBrowser didFindService:(NSNetService *)netService moreComing:(BOOL)moreServicesComing
{
//	NSLog(@"netservice %@", netService);
	
	PWBasePeer* peer = [self.browsingStrategy findService:netService onBrowseServer:self];
	
	[self.peers addObject:peer];
	
	[self.delegate invokeSelector:@selector(server:didUpdatePeerList:) withParameters:@[self, self.peers]];
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)netServiceBrowser didRemoveService:(NSNetService *)netService moreComing:(BOOL)moreServicesComing
{
	for (PWBasePeer* peer in self.peers)
	{
		if (peer.netService == netService)
		{
			[self.peers removeObject:peer];
			
			break;
		}
	}
	
	[self.delegate invokeSelector:@selector(server:didUpdatePeerList:) withParameters:@[self, self.peers]];
}

- (void)netServiceBrowserDidStopSearch:(NSNetServiceBrowser *)aNetServiceBrowser
{
	[self.peers removeAllObjects];
	
	[self.delegate invokeSelector:@selector(server:didUpdatePeerList:) withParameters:@[self, self.peers]];
}


@end
