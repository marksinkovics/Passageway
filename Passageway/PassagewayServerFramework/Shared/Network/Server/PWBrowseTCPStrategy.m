//
//  PWBrowseTCPStrategy.m
//  PassagewayServerFramework
//
//  Created by Mark Sinkovics on 2/3/13.
//
//

#import "PWBrowseTCPStrategy.h"
#import "PWBrowseServer.h"
#import "PWTCPPeer.h"

@implementation PWBrowseTCPStrategy

- (PWBasePeer*)findService:(NSNetService*)service onBrowseServer:(PWBrowseServer*)server
{
	PWTCPPeer* peer = [[PWTCPPeer alloc] initWithNetService:service];
	
	peer.delegate = server;
	
	return [peer autorelease];
}

@end
