//
//  PWMouseMacLib.h
//  PassagewayServerMac
//
//  Created by Mark Sinkovics on 4/14/13.
//
//

#import <Foundation/Foundation.h>


@interface PWMouseMacLib : NSObject
{
	
}
@end

void mouseAhead(float dx, float dy);

void mouseMove(float x, float y);

void mouseDrag();

void mouseDragAhead(float x, float y);

void mouseDragMove(float dx, float dy);

void mouseDragDrop();

void mouseLeftClick(int left, int clickCount);

void mouseScrollWheel(float dx, float dy);

