//
//  PWKeyboardMacLib.h
//  PassagewayServerMac
//
//  Created by Mark Sinkovics on 4/19/13.
//
//	http://ritter.ist.psu.edu/projects/RUI/macosx/rui.c
//	http://www.jacobward.co.uk/cgkeycode-list-objective-c/
//	http://developer.apple.com/library/mac/#DOCUMENTATION/Cocoa/Conceptual/EventOverview/MonitoringEvents/MonitoringEvents.html
//


#import <CoreGraphics/CoreGraphics.h>

@interface PWKeyboardMacLib : NSObject

@end

typedef struct _PWKeyCode
{
	char str[7];
	uint16_t keyCode;
	uint64_t functionKey;
	
} PWKeyCode;

PWKeyCode GetKeyCodeFromStr(const char* str, int* success);

void PressKeyCode(PWKeyCode keyCode);