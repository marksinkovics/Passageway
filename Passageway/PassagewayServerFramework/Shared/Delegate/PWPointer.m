//
//  PWPointer.m
//  PassagewayServerFramework
//
//  Created by Mark Sinkovics on 4/6/13.
//
//
// http://www.cocoawithlove.com/2010/10/testing-if-arbitrary-pointer-is-valid.html
//

#import <malloc/malloc.h>
#import <objc/runtime.h>

#import "PWPointer.h"

@implementation PWPointer

static sigjmp_buf sigjmp_env;

#pragma mark - Class Methods

+ (PWPointer*)pointerWithObject:(id)object
{	
	PWPointer* pointer = [[PWPointer alloc] initWithObject:object];
	
	return [pointer autorelease];
}

#pragma mark - Instance Methods

- (id)initWithObject:(id)object
{
	self = [super init];
	
	if (self)
	{
		_pointer = object;
	}
	
	return self;
}

- (void)dealloc
{
    _pointer = NULL;
	
    [super dealloc];
}

- (id)object
{
	BOOL allocatedLargeEnough;
	
	BOOL isMessageableObject = _isPointerAnObject(_pointer, &allocatedLargeEnough);
	
	if (isMessageableObject)
	{
		return _pointer;
	}
	else
	{
		return nil;
	}
}

- (BOOL)isEqual:(id)object
{
	BOOL result = NO;
	
	if ([object isKindOfClass:[self class]])
	{
		result = (self->_pointer == ((PWPointer*)object)->_pointer);
	}
	
	return result;
}

#pragma mark - Private Methods

void _pointerReadFailedHandler(int signum)
{
    siglongjmp (sigjmp_env, 1);
}

BOOL _isPointerAnObject(const void *testPointer, BOOL *allocatedLargeEnough)
{
	*allocatedLargeEnough = NO;
	
	// Set up SIGSEGV and SIGBUS handlers
	struct sigaction new_segv_action, old_segv_action;
	struct sigaction new_bus_action, old_bus_action;
	new_segv_action.sa_handler = _pointerReadFailedHandler;
	new_bus_action.sa_handler = _pointerReadFailedHandler;
	sigemptyset(&new_segv_action.sa_mask);
	sigemptyset(&new_bus_action.sa_mask);
	new_segv_action.sa_flags = 0;
	new_bus_action.sa_flags = 0;
	sigaction (SIGSEGV, &new_segv_action, &old_segv_action);
	sigaction (SIGBUS, &new_bus_action, &old_bus_action);
	
	// The signal handler will return us to here if a signal is raised
	if (sigsetjmp(sigjmp_env, 1))
	{
		sigaction (SIGSEGV, &old_segv_action, NULL);
		sigaction (SIGBUS, &old_bus_action, NULL);
		return NO;
	}
	
	Class testPointerClass = *((Class *)testPointer);
	
	// Get the list of classes and look for testPointerClass
	BOOL isClass = NO;
	int numClasses = objc_getClassList(NULL, 0);
	Class *classesList = malloc(sizeof(Class) * numClasses);
	numClasses = objc_getClassList(classesList, numClasses);
	for (int i = 0; i < numClasses; i++)
	{
		if (classesList[i] == testPointerClass)
		{
			isClass = YES;
			break;
		}
	}
	free(classesList);
	
	// We're done with the signal handlers (install the previous ones)
	sigaction (SIGSEGV, &old_segv_action, NULL);
	sigaction (SIGBUS, &old_bus_action, NULL);
	
	// Pointer does not point to a valid isa pointer
	if (!isClass)
	{
		return NO;
	}
	
	// Check the allocation size
	size_t allocated_size = malloc_size(testPointer);
	size_t instance_size = class_getInstanceSize(testPointerClass);
	if (allocated_size > instance_size)
	{
		*allocatedLargeEnough = YES;
	}
	
	return YES;
}

@end
