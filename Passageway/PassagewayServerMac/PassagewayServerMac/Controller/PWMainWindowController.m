//
//  PWMainWindowController.m
//  PassagewayServerMac
//
//  Created by Mark Sinkovics on 2/26/13.
//
//

#import "PWMainWindowController.h"
#import "PWMainController.h"

#import "PWStatView.h"


@implementation PWMainWindowController

- (id)init
{
    self = [super initWithWindowNibName:@"MainWindow"];
	
    if (self)
	{
		
    }
    
    return self;
}

#pragma mark - Memory Management

- (void)dealloc
{
    [super dealloc];
}

#pragma mark - User Action Methods

- (IBAction)startStopServerAction:(id)sender
{
	[self.mainController startStop];
	
	if ([self.mainController isActive])
	{
		[_statView start];
	}
	else
	{
		[_statView stop];
	}
	
	((NSButton*)sender).title = [self.mainController isActive] ? @"STOP" : @"START";
}

@end
