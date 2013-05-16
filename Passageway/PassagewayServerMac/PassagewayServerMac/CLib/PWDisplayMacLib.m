//
//  PWDisplayMacLib.m
//  PassagewayServerMac
//
//  Created by Mark Sinkovics on 4/24/13.
//
// http://www.eosgarden.com/en/articles/iokit-idle/
// http://stackoverflow.com/questions/5596319/how-to-programmatically-prevent-a-mac-from-going-to-sleep
// http://www.opensource.apple.com/source/IOGraphics/
//

#import "PWDisplayMacLib.h"

@implementation PWDisplayMacLib

@end

void ActivateDisplay(unsigned int activate)
{
	if (IsDisplayActive() == IsDisplayActive())
	{	
		io_registry_entry_t r = IORegistryEntryFromPath(kIOMasterPortDefault, "IOService:/IOResources/IODisplayWrangler");
		
		if (r)
		{
			CFBooleanRef enableRef = (activate == 0 ? kCFBooleanTrue : kCFBooleanFalse);
			
			IORegistryEntrySetCFProperty(r, CFSTR("IORequestIdle"), enableRef);
			
			IOObjectRelease(r);
		}
	}
}

unsigned int IsDisplayActive()
{
	return !CGDisplayIsAsleep(CGMainDisplayID());
}
