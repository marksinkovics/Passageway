//
//  PWRemoteViewController.h
//  PassagewayClientiOS
//
//  Created by Mark Sinkovics on 10/10/12.
//  Copyright (c) 2012 mscodefactory. All rights reserved.
//

#import <PWServer/PWServer.h>

@class PWStatInfoView;

@interface PWRemoteViewController : UIViewController <UIKeyInput, PWRemoteControlClientManagerDelegate, UITextFieldDelegate>
{
	PWMouseData		_mouseData;
	PWKeyboardData	_keyboardData;
	
	CGPoint _previouslocation;
	
	NSTimer* _schedulerTimer;
	
	UIToolbar* _functionKeysToolbar;
	
	__weak IBOutlet PWStatInfoView* _statInfoView;
	
	struct {
		unsigned int isNavigationBarHidden:1;
		unsigned int isKeyboardHidden:1;
    } __flag;
}

@property (nonatomic, weak) PWRemoteControlClientManager* clientManager;

#pragma mark - User Actions Methods

- (IBAction)stop:(id)sender;

- (IBAction)openKeyboard:(id)sender;

#pragma mark - Public Methods

- (void)navigationBarDidHide:(BOOL)hidden;

- (void)resetGestures;

#pragma mark - Input Device Methods

- (void)handleMouseLeftClick:(NSInteger)click atX:(float)x y:(float)y;

- (void)handleMouseRightClick:(NSInteger)click atX:(float)x y:(float)y;

- (void)handleMouseDragAtX:(float)x y:(float)y;

- (void)handleMouseDragDeltaAtX:(float)x y:(float)y;

- (void)handleMouseDragPositionAtX:(float)x y:(float)y;

- (void)handleMouseDragDropAtX:(float)x y:(float)y;

- (void)handleMouseDeltaAtX:(float)x y:(float)y;

- (void)handleMouseScrollAtX:(float)x y:(float)y;

- (void)handleKeyboardPressCharacters:(NSString*)characters;

@end
