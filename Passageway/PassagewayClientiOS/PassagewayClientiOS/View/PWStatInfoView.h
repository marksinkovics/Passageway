//
//  PWStatInfoView.h
//  PassagewayClientiOS
//
//  Created by Mark Sinkovics on 4/2/13.
//  Copyright (c) 2013 mscodefactory. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PWStatInfoView : UIView
{
	__weak IBOutlet UILabel* _memoryFreeLabel;
	__weak IBOutlet UILabel* _memoryInactiveLabel;
	__weak IBOutlet UILabel* _memoryUsedLabel;
	
	NSTimer* _refreshTimer;
}

- (void)refresh;

- (void)start;

- (void)stop;

@end
