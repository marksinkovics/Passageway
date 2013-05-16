//
//  PWMouseMacLib.m
//  PassagewayServerMac
//
//  Created by Mark Sinkovics on 4/14/13.
//
//	http://lists.apple.com/archives/carbon-dev/2006/Sep/msg00735.html
//

#import "PWMouseMacLib.h"

@implementation PWMouseMacLib

@end

CG_INLINE CGPoint _getCurrentMousePosition()
{
	CGEventRef emptyEvent = CGEventCreate(NULL);
	
	CGPoint point = CGEventGetLocation(emptyEvent);
	
	CFRelease(emptyEvent);
	
	return point;
}

void mouseAhead(float dx, float dy)
{
	CGPoint _currentPosition = _getCurrentMousePosition();
		
	CGPoint _newPosition = {_currentPosition.x + dx, _currentPosition.y + dy};
	
	CGEventRef eventRef = CGEventCreateMouseEvent(NULL, kCGEventMouseMoved, _newPosition, kCGMouseButtonCenter);
	
	CGEventSetType(eventRef, kCGEventMouseMoved);
	
	CGEventPost(kCGSessionEventTap, eventRef);
	
	CFRelease(eventRef);
}

void mouseMove(float x, float y)
{
	CGPoint _newPosition = {x, y};
	
	CGEventRef eventRef = CGEventCreateMouseEvent(NULL, kCGEventMouseMoved, _newPosition, kCGMouseButtonCenter);
	
	CGEventSetType(eventRef, kCGEventMouseMoved);
	
	CGEventPost(kCGSessionEventTap, eventRef);
	
	CFRelease(eventRef);
}

void mouseDrag()
{
	CGPoint _currentPosition = _getCurrentMousePosition();
		
	CGEventSourceRef source = CGEventSourceCreate (kCGEventSourceStateCombinedSessionState);
	
	CGEventRef eventMouseLeftDown  = CGEventCreateMouseEvent(source, kCGEventLeftMouseDown, _currentPosition, kCGMouseButtonLeft);
	
	CGEventSetType(eventMouseLeftDown, kCGEventLeftMouseDown);
	
	CGEventPost(kCGSessionEventTap, eventMouseLeftDown);
	
	CFRelease(eventMouseLeftDown);
		
	CFRelease(source);
}

void mouseDragAhead(float dx, float dy)
{
	CGPoint _currentPosition = _getCurrentMousePosition();
	
	CGPoint _newPosition = {_currentPosition.x + dx, _currentPosition.y + dy};
	
	CGEventSourceRef source = CGEventSourceCreate (kCGEventSourceStateCombinedSessionState);

	CGEventRef eventMouseLeftDrag  = CGEventCreateMouseEvent(source, kCGEventLeftMouseDragged, _newPosition, kCGMouseButtonLeft);
	
	CGEventSetType(eventMouseLeftDrag, kCGEventLeftMouseDragged);
		
	CGEventRef eventMouseLeftMove  = CGEventCreateMouseEvent(source, kCGEventMouseMoved, _newPosition, kCGMouseButtonLeft);
	
	CGEventSetType(eventMouseLeftMove, kCGEventMouseMoved);
	
	CGEventPost(kCGSessionEventTap, eventMouseLeftDrag);
	
	CGEventPost(kCGSessionEventTap, eventMouseLeftMove);	
	
	CFRelease(eventMouseLeftDrag);
		
	CFRelease(eventMouseLeftMove);
	
	CFRelease(source);
}

void mouseDragMove(float dx, float dy)
{	
	CGPoint _newPosition = {dx, dy};
	
	CGEventSourceRef source = CGEventSourceCreate (kCGEventSourceStateCombinedSessionState);
	
	CGEventRef eventMouseLeftDrag  = CGEventCreateMouseEvent(source, kCGEventLeftMouseDragged, _newPosition, kCGMouseButtonLeft);
	
	CGEventSetType(eventMouseLeftDrag, kCGEventLeftMouseDragged);
	
	CGEventRef eventMouseLeftMove  = CGEventCreateMouseEvent(source, kCGEventMouseMoved, _newPosition, kCGMouseButtonLeft);
	
	CGEventSetType(eventMouseLeftMove, kCGEventMouseMoved);
	
	CGEventPost(kCGSessionEventTap, eventMouseLeftDrag);
	
	CGEventPost(kCGSessionEventTap, eventMouseLeftMove);
	
	CFRelease(eventMouseLeftDrag);
	
	CFRelease(eventMouseLeftMove);
	
	CFRelease(source);
}

void mouseDragDrop()
{
	CGPoint _currentPosition = _getCurrentMousePosition();
	
	CGEventSourceRef source = CGEventSourceCreate (kCGEventSourceStateCombinedSessionState);
	
	CGEventRef eventMouseLeftUp  = CGEventCreateMouseEvent(source, kCGEventLeftMouseUp, _currentPosition, kCGMouseButtonLeft);
	
	CGEventSetType(eventMouseLeftUp, kCGEventLeftMouseUp);	
	
	CGEventPost(kCGSessionEventTap , eventMouseLeftUp);
	
	CFRelease(eventMouseLeftUp);
	
	CFRelease(source);
}

void mouseLeftClick(int left, int clickCount)
{
	CGEventType eventTypeDown	= left == 0 ? kCGEventLeftMouseDown : kCGEventRightMouseDown;
	
	CGEventType eventTypeUp		= left == 0 ? kCGEventLeftMouseUp	: kCGEventRightMouseUp;
	
	CGMouseButton mouseButton	= left == 0 ? kCGMouseButtonLeft	: kCGMouseButtonRight;
	
	
	CGPoint _currentPosition = _getCurrentMousePosition();
	
	CGEventSourceRef source = CGEventSourceCreate (kCGEventSourceStateCombinedSessionState);
	
	
	CGEventRef eventMouseDown  = CGEventCreateMouseEvent(source, eventTypeDown, _currentPosition, mouseButton);
	
	CGEventSetIntegerValueField(eventMouseDown, kCGMouseEventClickState, clickCount);
	
	CGEventSetType(eventMouseDown, eventTypeDown);
	
	
	CGEventRef eventMouseUp  = CGEventCreateMouseEvent(source, eventTypeUp, _currentPosition, mouseButton);
	
	CGEventSetIntegerValueField(eventMouseUp, kCGMouseEventClickState, clickCount);
	
	CGEventSetType(eventMouseUp, eventTypeUp);
	

	CGEventPost(kCGSessionEventTap, eventMouseDown);
	
	CGEventPost(kCGSessionEventTap, eventMouseUp);
	
	CFRelease(eventMouseDown);
	
	CFRelease(eventMouseUp);
	
	
	CFRelease(source);
}

void mouseScrollWheel(float dx, float dy)
{
	CGEventRef event = CGEventCreateScrollWheelEvent(NULL, kCGScrollEventUnitPixel, 2, (uint32_t)dx, (uint32_t)dy, NULL);
	
	CGEventSetIntegerValueField(event, kCGScrollWheelEventInstantMouser, 0);
	
	CGEventPost(kCGSessionEventTap, event);
	
	CFRelease(event);
}
