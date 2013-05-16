//
//  PWDelegateController.m
//  PassagewayServerFramework
//
//  Created by Mark Sinkovics on 12/26/12.
//

#import "PWDelegateController.h"
#import "PWPointer.h"

@interface PWDelegateController ()

@property (nonatomic, strong, readwrite) NSMutableArray *delegates;
@property (nonatomic, strong, readwrite) Protocol *protocol;
@end

@implementation PWDelegateController

@synthesize delegates = _delegates;

#pragma mark - Class Methods

+ (PWDelegateController*)delegateWithProtocol:(Protocol *)protocol
{
	PWDelegateController* _delegate = [[PWDelegateController alloc] initWithProtocol:protocol];
	
	return [_delegate autorelease];
}

#pragma mark - Instance Methods

- (id)initWithProtocol:(Protocol *)protocol
{
    self = [super init];
	
    if (self)
	{
		self.delegates = [NSMutableArray array];
		
		self.protocol = protocol;
    }
    return self;
}

- (void)dealloc
{
	[self.delegates removeAllObjects];
	
	self.delegates = nil;
	
	self.protocol = nil;
	
	[super dealloc];
}

#pragma mark - Private Methods

- (BOOL)_isContainedValue:(NSValue*)value
{
	BOOL isContained = NO;
	
	for (NSValue* v in self.delegates)
	{
		if ([value isEqualToValue:v])
		{
			isContained = YES;
			
			break;
		}
	}
	
	return isContained;
}

- (void)_storeObject:(id)object;
{
	PWPointer* p = [PWPointer pointerWithObject:object];
	
	if ([self.delegates containsObject:p] == NO)
	{
		[self.delegates addObject:p];
	}
}

- (void)_removeObject:(id)object
{
	PWPointer* p = [PWPointer pointerWithObject:object];
	
	if ([self.delegates containsObject:p])
	{
		[self.delegates removeObject:p];
	}
}

#pragma mark - Add/Remove Delegates

- (void)addDelegate:(id)delegate
{
	if (delegate == nil)
	{
		return;
	}
	
	if (self.protocol)
	{
		if ([delegate conformsToProtocol:self.protocol])
		{
			[self _storeObject:delegate];
		}
	}
	else
	{
		[self _storeObject:delegate];
	}
}

- (void)removeDelegate:(id)delegate
{
	if (delegate == nil)
	{
		return;
	}
	
	[self _removeObject:delegate];
}

- (void)removeAllDelegates
{
	[self.delegates removeAllObjects];
}

#pragma mark - Invoke Methods

- (void)invokeSelector:(SEL)selector
{
	[self invokeSelector:selector withParameters:@[]];
}

- (void)invokeSelector:(SEL)selector withParameters:(NSArray *)parameters
{
	NSMutableArray* _invalidPointers = [NSMutableArray array];
	
	for (PWPointer* pointer in self.delegates)
	{
		id delegateObj = [pointer object];
		
		if (delegateObj)
		{
			if ([delegateObj respondsToSelector:selector])
			{
				NSInvocation *inv = [NSInvocation invocationWithMethodSignature:[delegateObj methodSignatureForSelector:selector]];
				
				[inv setSelector:selector];
				
				[inv setTarget:delegateObj];
				
				//arguments 0 and 1 are self and _cmd respectively, automatically set by NSInvocation
				
				for (int i = 2; i < parameters.count + 2; i++)
				{
					NSObject *obj = [parameters objectAtIndex:(i-2)];
					
					[inv setArgument:&obj atIndex:i];
				}
				
				[inv invoke];
			}
		}
		else
		{
			[_invalidPointers addObject:pointer];
		}
	}
	
	[self.delegates removeObjectsInArray:_invalidPointers];
}

@end
