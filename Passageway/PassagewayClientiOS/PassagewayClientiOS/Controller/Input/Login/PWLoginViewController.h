//
//  PWLoginViewController.h
//  PassagewayClientiOS
//
//  Created by Mark Sinkovics on 3/20/13.
//  Copyright (c) 2013 mscodefactory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PWInputViewControllerDelegate.h"

@protocol PWLoginViewControllerDelegate;

@interface PWLoginViewController : UIViewController
{
    __weak IBOutlet UITextField* _usernameTextField;
    __weak IBOutlet UITextField* _passwordTextField;
    __weak IBOutlet UIButton* _loginButton;
    __weak IBOutlet UIActivityIndicatorView* _activityIndicator;
}
@property (nonatomic, weak) id<PWLoginViewControllerDelegate> delegate;

- (IBAction)login:(id)sender;

- (IBAction)cancel:(id)sender;

- (void)accessWasSuccessful:(BOOL)successful;

@end


@protocol PWLoginViewControllerDelegate <NSObject, PWInputViewControllerDelegate>

- (void)viewController:(PWLoginViewController*)viewController didAddUsername:(NSString*)username withPassword:(NSString*)password;

@end