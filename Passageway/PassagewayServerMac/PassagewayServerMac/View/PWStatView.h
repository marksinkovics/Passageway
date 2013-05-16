//
//  PWStatView.h
//  PassagewayServerMac
//
//  Created by Mark Sinkovics on 4/3/13.
//
//

#import <Cocoa/Cocoa.h>

@interface PWStatView : NSView
{
	IBOutlet NSTextField *_memoryFreeLabel;
	IBOutlet NSTextField *_memoryInactiveLabel;
	IBOutlet NSTextField *_memoryUsedLabel;

	NSTimer* _refreshTimer;
}

- (void)refresh;

- (void)start;

- (void)stop;

@end
