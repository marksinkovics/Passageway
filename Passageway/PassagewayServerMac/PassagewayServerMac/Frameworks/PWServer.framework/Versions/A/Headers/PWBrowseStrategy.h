//
//  PWBrowseStrategy.h
//  PassagewayServerFramework
//
//  Created by Mark Sinkovics on 2/3/13.
//
//

#import <Foundation/Foundation.h>

@class PWBasePeer;
@class PWBrowseServer;

@protocol PWBrowseStrategy <NSObject>
@required

- (PWBasePeer*)findService:(NSNetService*)service onBrowseServer:(PWBrowseServer*)server;

@end
