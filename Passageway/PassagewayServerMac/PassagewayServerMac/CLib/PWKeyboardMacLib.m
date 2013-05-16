//
//  PWKeyboardMacLib.m
//  PassagewayServerMac
//
//  Created by Mark Sinkovics on 4/19/13.
//

#import "PWKeyboardMacLib.h"

@implementation PWKeyboardMacLib

@end

#define TranslateStrToKeyCode(_strA_, _strB_, _keyCode_, _functionKeys_) \
	if (strcmp(_strA_, _strB_) == 0) { \
		PWKeyCode result; \
		result.keyCode = _keyCode_; \
		result.functionKey = _functionKeys_; \
		return result; \
	}

PWKeyCode GetKeyCodeFromStr(const char* str, int* success)
{
	*success = YES;
	
	TranslateStrToKeyCode(str, "a", 0, 0);
	TranslateStrToKeyCode(str, "A", 0, kCGEventFlagMaskShift);
	TranslateStrToKeyCode(str, "s", 1, 0);
	TranslateStrToKeyCode(str, "S", 1, kCGEventFlagMaskShift);
	TranslateStrToKeyCode(str, "d", 2, 0);
	TranslateStrToKeyCode(str, "D", 2, kCGEventFlagMaskShift);
	TranslateStrToKeyCode(str, "f", 3, 0);
	TranslateStrToKeyCode(str, "F", 3, kCGEventFlagMaskShift);
	TranslateStrToKeyCode(str, "h", 4, 0);
	TranslateStrToKeyCode(str, "H", 4, kCGEventFlagMaskShift);
	TranslateStrToKeyCode(str, "g", 5, 0);
	TranslateStrToKeyCode(str, "G", 5, kCGEventFlagMaskShift);
	TranslateStrToKeyCode(str, "z", 6, 0);
	TranslateStrToKeyCode(str, "Z", 6, kCGEventFlagMaskShift);
	TranslateStrToKeyCode(str, "x", 7, 0);
	TranslateStrToKeyCode(str, "X", 7, kCGEventFlagMaskShift);
	TranslateStrToKeyCode(str, "c", 8, 0);
	TranslateStrToKeyCode(str, "C", 8, kCGEventFlagMaskShift);
	TranslateStrToKeyCode(str, "v", 9, 0);
	TranslateStrToKeyCode(str, "V", 9, kCGEventFlagMaskShift);
	
	TranslateStrToKeyCode(str, "b", 11, 0);
	TranslateStrToKeyCode(str, "B", 11, kCGEventFlagMaskShift);
	TranslateStrToKeyCode(str, "q", 12, 0);
	TranslateStrToKeyCode(str, "Q", 12, kCGEventFlagMaskShift);
	TranslateStrToKeyCode(str, "w", 13, 0);
	TranslateStrToKeyCode(str, "W", 13, kCGEventFlagMaskShift);
	TranslateStrToKeyCode(str, "e", 14, 0);
	TranslateStrToKeyCode(str, "E", 14, kCGEventFlagMaskShift);
	TranslateStrToKeyCode(str, "r", 15, 0);
	TranslateStrToKeyCode(str, "R", 15, kCGEventFlagMaskShift);
	TranslateStrToKeyCode(str, "y", 16, 0);
	TranslateStrToKeyCode(str, "Y", 16, kCGEventFlagMaskShift);
	TranslateStrToKeyCode(str, "t", 17, 0);
	TranslateStrToKeyCode(str, "T", 17, kCGEventFlagMaskShift);

	TranslateStrToKeyCode(str, "1", 18, 0);
	TranslateStrToKeyCode(str, "2", 19, 0);
	TranslateStrToKeyCode(str, "3", 20, 0);
	TranslateStrToKeyCode(str, "4", 21, 0);
	TranslateStrToKeyCode(str, "6", 22, 0);
	TranslateStrToKeyCode(str, "5", 23, 0);
	
	TranslateStrToKeyCode(str, "=", 24, 0);
	
	TranslateStrToKeyCode(str, "9", 25, 0);
	TranslateStrToKeyCode(str, "7", 26, 0);
	
	TranslateStrToKeyCode(str, "-", 27, 0);
	
	TranslateStrToKeyCode(str, "8", 28, 0);
	TranslateStrToKeyCode(str, "0", 29, 0);
	
	TranslateStrToKeyCode(str, "]", 30, 0);
	
	TranslateStrToKeyCode(str, "o", 31, 0);
	TranslateStrToKeyCode(str, "O", 31, kCGEventFlagMaskShift);
	TranslateStrToKeyCode(str, "u", 32, 0);
	TranslateStrToKeyCode(str, "U", 32, kCGEventFlagMaskShift);
	
	TranslateStrToKeyCode(str, "[", 33, 0);
	
	TranslateStrToKeyCode(str, "i", 34, 0);
	TranslateStrToKeyCode(str, "I", 34, kCGEventFlagMaskShift);
	TranslateStrToKeyCode(str, "p", 35, 0);
	TranslateStrToKeyCode(str, "P", 35, kCGEventFlagMaskShift);
	
	TranslateStrToKeyCode(str, "RETURN", 36, 0);
	
	TranslateStrToKeyCode(str, "l", 37, 0);
	TranslateStrToKeyCode(str, "L", 37, kCGEventFlagMaskShift);
	TranslateStrToKeyCode(str, "j", 38, 0);
	TranslateStrToKeyCode(str, "J", 38, kCGEventFlagMaskShift);
	
	TranslateStrToKeyCode(str, "'", 39, 0);
	
	TranslateStrToKeyCode(str, "k", 40, 0);
	TranslateStrToKeyCode(str, "K", 40, kCGEventFlagMaskShift);
	
	TranslateStrToKeyCode(str, ";", 41, 0);
	TranslateStrToKeyCode(str, "\\", 42, 0);
	TranslateStrToKeyCode(str, ",", 43, 0);
	TranslateStrToKeyCode(str, "/", 44, 0);
	
	TranslateStrToKeyCode(str, "n", 45, 0);
	TranslateStrToKeyCode(str, "N", 45, kCGEventFlagMaskShift);	
	TranslateStrToKeyCode(str, "m", 46, 0);
	TranslateStrToKeyCode(str, "M", 46, kCGEventFlagMaskShift);
	
	TranslateStrToKeyCode(str, ".", 47, 0);
	TranslateStrToKeyCode(str, "TAB", 48, 0);
	TranslateStrToKeyCode(str, "SPC", 49, 0);
	TranslateStrToKeyCode(str, " ", 49, 0);
	TranslateStrToKeyCode(str, "`", 50, 0);
	TranslateStrToKeyCode(str, "DEL", 51, 0);
	TranslateStrToKeyCode(str, "ENTER", 52, 0);
	TranslateStrToKeyCode(str, "ESC", 53, 0);
	
	TranslateStrToKeyCode(str, ".", 65, 0);
	TranslateStrToKeyCode(str, "*", 67, 0);
	TranslateStrToKeyCode(str, "+", 69, 0);
	
	TranslateStrToKeyCode(str, "CLR", 71, 0);
	TranslateStrToKeyCode(str, "/", 75, 0);
	TranslateStrToKeyCode(str, "ENTER", 76, 0); // numberpad on full kbd
	
	TranslateStrToKeyCode(str, "=", 81, 0);
	TranslateStrToKeyCode(str, "0", 82, 0);
	TranslateStrToKeyCode(str, "1", 83, 0);
	TranslateStrToKeyCode(str, "2", 84, 0);
	TranslateStrToKeyCode(str, "3", 85, 0);
	TranslateStrToKeyCode(str, "4", 86, 0);
	TranslateStrToKeyCode(str, "5", 87, 0);
	TranslateStrToKeyCode(str, "6", 88, 0);
	TranslateStrToKeyCode(str, "7", 89, 0);
	
	TranslateStrToKeyCode(str, "8", 91, 0);
	TranslateStrToKeyCode(str, "9", 92, 0);
	
	TranslateStrToKeyCode(str, "F5", 96, 0);
	TranslateStrToKeyCode(str, "F6", 97, 0);
	TranslateStrToKeyCode(str, "F7", 98, 0);
	TranslateStrToKeyCode(str, "F3", 99, 0);
	TranslateStrToKeyCode(str, "F8", 100, 0);
	TranslateStrToKeyCode(str, "F9", 101, 0);
	TranslateStrToKeyCode(str, "F11", 103, 0);
	TranslateStrToKeyCode(str, "F13", 105, 0);
	TranslateStrToKeyCode(str, "F9", 101, 0);
	TranslateStrToKeyCode(str, "F14", 107, 0);
	TranslateStrToKeyCode(str, "F10", 109, 0);
	TranslateStrToKeyCode(str, "F12", 111, 0);
	
	TranslateStrToKeyCode(str, "F15", 113, 0);
	TranslateStrToKeyCode(str, "HELP", 114, 0);
	TranslateStrToKeyCode(str, "HOME", 115, 0);
	TranslateStrToKeyCode(str, "PGUP", 116, 0);
	TranslateStrToKeyCode(str, "DEL", 117, 0);
	TranslateStrToKeyCode(str, "F4", 118, 0);
	TranslateStrToKeyCode(str, "END", 119, 0);
	TranslateStrToKeyCode(str, "F2", 120, 0);
	TranslateStrToKeyCode(str, "PGDOWN", 121, 0);

	TranslateStrToKeyCode(str, "F1", 122, 0);
	TranslateStrToKeyCode(str, "LFT", 123, 0);
	TranslateStrToKeyCode(str, "RIGHT", 124, 0);
	TranslateStrToKeyCode(str, "DOWN", 125, 0);
	TranslateStrToKeyCode(str, "UP", 126, 0);
	
	*success = NO;
	
	PWKeyCode keyCode;
	
	return keyCode;
}

void PressKeyCode(PWKeyCode keyCode)
{
	CGEventRef keyboardEventDown = CGEventCreateKeyboardEvent(NULL, keyCode.keyCode, true);
	
	CGEventSetFlags(keyboardEventDown, keyCode.functionKey);
	
	CGEventPost(kCGSessionEventTap, keyboardEventDown);
	
	CGEventRef keyboardEventUp = CGEventCreateKeyboardEvent(NULL, keyCode.keyCode, false);
	
	CGEventSetFlags(keyboardEventUp, keyCode.functionKey);
	
	CGEventPost(kCGSessionEventTap, keyboardEventUp);
}