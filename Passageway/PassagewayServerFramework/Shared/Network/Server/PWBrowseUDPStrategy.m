//
//  PWBrowseUDPStrategy.m
//  PassagewayServerFramework
//
//  Created by Mark Sinkovics on 2/3/13.
//
//

#import "PWBrowseUDPStrategy.h"
#import "PWBrowseServer.h"
#import "PWUDPPeer.h"

@implementation PWBrowseUDPStrategy

- (PWBasePeer*)findService:(NSNetService*)service onBrowseServer:(PWBrowseServer*)server
{
	PWUDPPeer* peer = [[PWUDPPeer alloc] initWithNetService:service];
	
	peer.delegate = server;
	
	return [peer autorelease];
}

@end
