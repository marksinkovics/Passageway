//
//  PWMainWindowController.h
//  PassagewayServerMac
//
//  Created by Mark Sinkovics on 2/26/13.
//
//

#import <Cocoa/Cocoa.h>

@class PWStatView;
@class PWMainController;

@interface PWMainWindowController : NSWindowController
{
	IBOutlet PWStatView *_statView;
}

@property (nonatomic, assign) PWMainController* mainController;

- (IBAction)startStopServerAction:(id)sender;

@end
