//
//  PWCommunicationManager.m
//  PassagewayServerFramework
//
//  Created by Mark Sinkovics on 3/8/13.
//
//

#import "PWCommunicationManager.h"

@implementation PWCommunicationManager

#pragma mark - Class Methods

+ (id)manager
{
	return nil;
}

#pragma mark - General Methods

- (id)init
{
    self = [super init];
	
    if (self)
	{
		[[MSJSONMapperManager sharedManager] addTemplateWithMappedObject:[PWMsgAccessRequest class]];
		
		[[MSJSONMapperManager sharedManager] addTemplateWithMappedObject:[PWMsgAccessResponse class]];
		
		[[MSJSONMapperManager sharedManager] addTemplateWithMappedObject:[PWMsgControlRequest class]];
		
		[[MSJSONMapperManager sharedManager] addTemplateWithMappedObject:[PWMsgControlResponse class]];
		
		_private_concurrent_queue = dispatch_queue_create("com.passagewayservice.concurrent", DISPATCH_QUEUE_CONCURRENT);
		
		_private_serial_queue = dispatch_queue_create("com.passagewayservice.serial", DISPATCH_QUEUE_SERIAL);
		
		
    }
    return self;
}

- (void)dealloc
{
	NSLog(@"%s", __PRETTY_FUNCTION__);
	
	[[MSJSONMapperManager sharedManager] destroy];
	
	dispatch_release(_private_concurrent_queue);
	
	dispatch_release(_private_serial_queue);	
    
    [super dealloc];
}

- (void)start
{

}

- (void)stop
{

}

- (BOOL)active
{
	return NO;
}

#pragma mark - PWBaseServerDelegate Methods

- (void)server:(PWBaseServer*)server didStartWithInfo:(NSString*)info
{
	
}

- (void)server:(PWBaseServer*)server didStopWithReason:(NSError*)error
{
	
}

- (void)server:(PWBaseServer*)server didConnectToPeer:(PWBasePeer*)peer
{

}

- (void)server:(PWBaseServer*)server didDisconnectFromPeer:(PWBasePeer*)peer
{
	
}

- (void)server:(PWBaseServer*)server didReceiveData:(NSData*)data fromPeer:(PWBasePeer*)peer
{
	
}

- (void)server:(PWBaseServer*)server didUpdatePeerList:(NSArray*)peerList
{
	
}

@end
