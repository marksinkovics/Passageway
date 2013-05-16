//
//  PWDelegateController.h
//  PassagewayServerFramework
//
//  Created by Mark Sinkovics on 12/26/12.
//
//

#import <Foundation/Foundation.h>

@interface PWDelegateController : NSObject
{
	NSMutableArray	*_delegates;
	Protocol		*_protocol;
}

@property (nonatomic, strong, readonly) NSMutableArray *delegates;
@property (nonatomic, strong, readonly) Protocol *protocol;

#pragma mark - Class Methods

+ (PWDelegateController*)delegateWithProtocol:(Protocol*)protocol;

#pragma mark - Instance Methods

- (id)initWithProtocol:(Protocol*)protocol;

#pragma mark - Add/Remove Delegates

- (void)addDelegate:(id)delegate;

- (void)removeDelegate:(id)delegate;

- (void)removeAllDelegates;

#pragma mark - Invoke Methods

- (void)invokeSelector:(SEL)selector;

- (void)invokeSelector:(SEL)selector withParameters:(NSArray*)parameters;

@end
