//
//  PWInputViewControllerDelegate.h
//  PassagewayClientiOS
//
//  Created by Mark Sinkovics Work on 21/03/13.
//  Copyright (c) 2013 mscodefactory. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PWInputViewControllerDelegate <NSObject>

- (void)didShowViewController:(UIViewController*)viewController;

- (void)didCancelViewController:(UIViewController*)viewController;

- (void)didHideViewController:(UIViewController*)viewController;

@end
