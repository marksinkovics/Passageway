//
//  PWMsgBase.h
//  PassagewayServerFramework
//
//  Created by Mark Sinkovics on 3/6/13.
//
//
// https://developer.apple.com/library/mac/#documentation/Darwin/Conceptual/64bitPorting/transition/transition.html
//
//

#ifndef PassagewayServerFramework_PWMsgBase_h
#define PassagewayServerFramework_PWMsgBase_h

#pragma mark - Image Header

typedef struct _PWUDPImageHeader
{
	unsigned short index;
	unsigned short ref;
	
} PWUDPImageHeader;

#pragma mark - Mouse Data Type

typedef enum _PWMouseDataType {
	PWMouseDataTypeLeftClick		= 0,
	PWMouseDataTypeLeftDoubleClick	= 1,
	PWMouseDataTypeRightClick		= 2,
	PWMouseDataTypePosition			= 3,
	PWMouseDataTypeDelta			= 4,
	PWMouseDataTypeDrag				= 5,
	PWMouseDataTypeDragDelta		= 6,
	PWMouseDataTypeDragPosition		= 7,
	PWMouseDataTypeDragDrop			= 8,
	PWMouseDataTypeScroll			= 9
} PWMouseDataType;

typedef struct _PWMouseData
{
	float dx;
	float dy;
	unsigned int type:4;
	unsigned int unused:4;	
	
} PWMouseData;

#pragma mark - Keyboard Data Type

typedef enum _PWKeyboardDataType
{
	PWKeyboardDataTypeCommand	= 1 << 0,
	PWKeyboardDataTypeControl	= 1 << 1,
	PWKeyboardDataTypeShift		= 1 << 2,
	PWKeyboardDataTypeAlt		= 1 << 3,
	
} PWKeyboardDataType;

typedef struct _PWKeyboardData
{
	char str[7];
	unsigned int functionKeys:4;
	unsigned int unused:4;

} PWKeyboardData;

#endif
