//
//  PWBrowseServer.h
//  PassagewayServerFramework
//
//  Created by Mark Sinkovics on 1/3/13.
//
//

#import "PWBaseServer.h"
#import "PWBrowseStrategy.h"

@interface PWBrowseServer : PWBaseServer <NSNetServiceBrowserDelegate>
{
	NSNetServiceBrowser*	_netServiceBrowser;
	
	id<PWBrowseStrategy> _browsingStrategy;
}

@property (nonatomic, strong) NSNetServiceBrowser* netServiceBrowser;
@property (nonatomic, strong) id<PWBrowseStrategy> browsingStrategy;

@end
