//
//  PWDisplayMacLib.h
//  PassagewayServerMac
//
//  Created by Mark Sinkovics on 4/24/13.
//
//

#import <Foundation/Foundation.h>

@interface PWDisplayMacLib : NSObject

@end

void ActivateDisplay(unsigned int activate);

unsigned int IsDisplayActive();
