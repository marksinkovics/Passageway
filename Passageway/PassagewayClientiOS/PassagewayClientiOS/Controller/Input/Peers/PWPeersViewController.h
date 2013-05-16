//
//  PWPeersViewController.h
//  PassagewayClientiOS
//
//  Created by Mark Sinkovics on 3/19/13.
//  Copyright (c) 2013 mscodefactory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PWServer/PWServer.h>

#import "PWInputViewControllerDelegate.h"

@protocol PWPeersViewControllerDelegate;

@interface PWPeersViewController : UITableViewController

@property (nonatomic, weak) id<PWPeersViewControllerDelegate> delegate;

/*!
 @method
 @param peers
 */
- (void)updateListWithPeers:(NSArray*)peers;

- (IBAction)cancel:(id)sender;

@end

@protocol PWPeersViewControllerDelegate <NSObject, PWInputViewControllerDelegate>

- (void)viewController:(PWPeersViewController*)viewController didSelectPeer:(PWBasePeer*)peer;

@end
