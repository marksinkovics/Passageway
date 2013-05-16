//
//  PWLoginViewController.m
//  PassagewayClientiOS
//
//  Created by Mark Sinkovics on 3/20/13.
//  Copyright (c) 2013 mscodefactory. All rights reserved.
//

#import "PWLoginViewController.h"

@interface PWLoginViewController ()

@end

@implementation PWLoginViewController

#pragma mark - Private Methods

- (BOOL)_validateTextFields
{
    BOOL result = NO;
    
    NSString* trimmedUsernameText = [_usernameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSString* trimmedPasswordText = [_passwordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (trimmedUsernameText.length > 0 && trimmedPasswordText.length > 0)
    {
        result = YES;
    }
    
    return result;
}

- (void)_inputsEnable:(BOOL)enable
{
    _usernameTextField.enabled = enable;
    
    _passwordTextField.enabled = enable;
    
    _loginButton.enabled = enable;
    
    _loginButton.alpha = enable ? 1.0 : 0.5;
    
    _activityIndicator.hidden = !enable;
    
    if (enable)
    {
        [_activityIndicator stopAnimating];
    }
    else
    {
        [_activityIndicator startAnimating];
    }
}

#pragma mark - Public Methods

- (void)accessWasSuccessful:(BOOL)successful
{
	_usernameTextField.text = @"";
	
	_passwordTextField.text = @"";
	
	[self _inputsEnable:YES];

    if (successful)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - User Action Methods

- (IBAction)login:(id)sender
{
    if([self _validateTextFields])
    {
        if(self.delegate && [self.delegate respondsToSelector:@selector(viewController:didAddUsername:withPassword:)])
        {
            [self _inputsEnable:NO];
            
            [self.delegate viewController:self
                           didAddUsername:_usernameTextField.text
                             withPassword:_passwordTextField.text];
        }
    }
}

- (IBAction)cancel:(id)sender
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(didCancelViewController:)])
    {
        [self.delegate didCancelViewController:self];
    }
}

@end
