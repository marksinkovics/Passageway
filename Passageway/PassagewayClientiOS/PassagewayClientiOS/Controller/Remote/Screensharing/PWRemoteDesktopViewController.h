//
//  PWRemoteDesktopViewController.h
//  PassagewayClientiOS
//
//  Created by Mark Sinkovics on 10/10/12.
//  Copyright (c) 2012 mscodefactory. All rights reserved.
//

#import "PWRemoteViewController.h"

@class PWRemoteDesktopView;

@interface PWRemoteDesktopViewController : PWRemoteViewController <UIScrollViewDelegate>
{
	__weak IBOutlet UIScrollView* _remoteDesktopScrollView;
	__weak IBOutlet PWRemoteDesktopView *_remoteDesktopView;
	
	dispatch_queue_t _private_queue;
}

@property (nonatomic, strong) PWMsgControlResponse* screenSharingResponse;

@end
