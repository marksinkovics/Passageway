//
//  PWRemoteControlServerManagerDelegate.h
//  PassagewayServerFramework
//
//  Created by Mark Sinkovics on 4/11/13.
//
//

#import <Foundation/Foundation.h>

@class PWRemoteControlServerManager;

@protocol PWRemoteControlServerManagerDelegate <NSObject>

@required

#pragma mark - General Delegate Methods

- (BOOL)manager:(PWRemoteControlServerManager*)manager validateUsername:(NSString*)username withPassword:(NSString*)password;

#pragma mark - Screen Sharing Methods

- (BOOL)shouldScreenSharingForManager:(PWRemoteControlServerManager*)manager;

- (void)startScreenSharingForManager:(PWRemoteControlServerManager*)manager;

- (void)stopScreenSharingForManager:(PWRemoteControlServerManager*)manager;

- (void)manager:(PWRemoteControlServerManager*)manager numTileHotizontal:(int*)horizontal numTileVertical:(int*)vertical tileWidth:(float*)width tileHeight:(float*)height;

- (NSInteger)numberOfDataForScreenSharingForManager:(PWRemoteControlServerManager*)manager;

- (NSData*)manager:(PWRemoteControlServerManager*)manager dataForScreenSharingAtIndex:(NSInteger)index;

#pragma mark - Remote Device Delegate Methods

- (BOOL)shouldRemoteDeviceForManager:(PWRemoteControlServerManager*)manager;

- (void)manager:(PWRemoteControlServerManager *)manager didReceiveRemoteDeviceData:(NSData*)data byRemoteDeviceType:(PWCommunicationRemoteDeviceType)deviceType;

@end
