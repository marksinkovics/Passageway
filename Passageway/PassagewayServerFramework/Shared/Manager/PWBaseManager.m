//
//  PWBaseManager.m
//  PassagewayServerFramework
//
//  Created by Mark Sinkovics on 12/26/12.
//
//

#import "PWBaseManager.h"

@implementation PWBaseManager

+ (PWBaseManager*)sharedManager
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
    
    return nil;
}

#pragma mark - Singleton Methods

+ (id)allocWithZone:(NSZone *)zone
{
    return [[self sharedManager] retain];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (NSUInteger)retainCount
{
    //denotes an object that cannot be released
    return NSUIntegerMax;
}

- (oneway void)release
{
    //do nothing
}

- (id)autorelease
{
    return self;
}

+ (id)createInstance
{
    return [[super allocWithZone:NULL] init];
}

#pragma mark - Instance Methods

- (id)init
{
    self = [super init];
    
    if (self)
    {
		
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)destroy
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

@end
