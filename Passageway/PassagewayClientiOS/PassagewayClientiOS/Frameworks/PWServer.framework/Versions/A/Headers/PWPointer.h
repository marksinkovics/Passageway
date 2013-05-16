//
//  PWPointer.h
//  PassagewayServerFramework
//
//  Created by Mark Sinkovics on 4/6/13.
//
//

#import <Foundation/Foundation.h>

@interface PWPointer : NSObject
{
	void* _pointer;
}

#pragma mark - Class Methods

+ (PWPointer*)pointerWithObject:(id)object;

#pragma mark - Instance Methods

- (id)initWithObject:(id)object;

- (id)object;

@end
