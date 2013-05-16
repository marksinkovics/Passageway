//
//  PWStateBarButtonItem.h
//  PassagewayClientiOS
//
//  Created by Mark Sinkovics on 5/8/13.
//  Copyright (c) 2013 mscodefactory. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PWStateBarButtonItem : UIBarButtonItem
{
	id	_realTarget;
	SEL _realAction;
}

@property (nonatomic, readonly) BOOL selected;

@end
