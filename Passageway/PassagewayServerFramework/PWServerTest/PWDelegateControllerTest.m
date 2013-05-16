//
//  PWDelegateControllerTest.m
//  PassagewayServerFramework
//
//  Created by Mark Sinkovics on 3/3/13.
//
//

#import "PWDelegateControllerTest.h"

@implementation PWTestDelegate

- (void)sayHello
{
	[PWDelegateControllerTest increaseCounter];
}

- (void)sayGoodBye
{
	[PWDelegateControllerTest increaseCounter];
}

- (void)methodWithInput1:(NSString*)input1 input2:(NSString*)input2
{
	[PWDelegateControllerTest increaseCounter];
}

@end

@implementation PWTest2Delegate

- (void)sayHello
{
	[PWDelegateControllerTest increaseCounter];
}

- (void)methodWithInput1:(NSString*)input1 input2:(NSString*)input2
{
	[PWDelegateControllerTest increaseCounter];
}

@end

@implementation PWDelegateControllerTest

static NSInteger counter = 0;

- (void)setUp
{
	[super setUp];
	
	counter = 0;
}

- (void)tearDown
{
	[_delegate release], _delegate = nil;
	
	[super tearDown];
}

+ (void)increaseCounter
{
	counter++;
}

- (void)testInstance
{
	STAssertNil(_delegate, @"_delegate should be nil");
}

- (void)testOneDelegate
{
	_delegate = [[PWDelegateController alloc] initWithProtocol:nil];
	
	PWTestDelegate* delegate1 = [[PWTestDelegate alloc] init];
	
	[_delegate addDelegate:delegate1];
	
	[_delegate invokeSelector:@selector(sayHello)];
	
	STAssertTrue(counter == 1, @"delegate object's method should be called once");
}

- (void)testManyDelegate
{
	_delegate = [[PWDelegateController alloc] initWithProtocol:nil];
	
	PWTestDelegate* delegate1 = [[PWTestDelegate alloc] init];
	
	PWTestDelegate* delegate2 = [[PWTestDelegate alloc] init];
	
	[_delegate addDelegate:delegate1];
	
	[_delegate addDelegate:delegate2];
	
	[_delegate invokeSelector:@selector(sayHello)];
	
	STAssertTrue(counter == 2, @"delegate object's method should be called twice");
}

- (void)testManyDelegateWithProtocol
{
	_delegate = [[PWDelegateController alloc] initWithProtocol:@protocol(PWTestProtocol)];
	
	PWTestDelegate* delegate1 = [[PWTestDelegate alloc] init];
	
	PWTest2Delegate* delegate2 = [[PWTest2Delegate alloc] init];
	
	[_delegate addDelegate:delegate1];
	
	[_delegate addDelegate:delegate2];
	
	[_delegate invokeSelector:@selector(sayGoodBye)];
	
	STAssertTrue(counter == 1, @"delegate object's method should be called once");
}

- (void)testManyDelegateWithInputs
{
	_delegate = [[PWDelegateController alloc] initWithProtocol:nil];
	
	PWTestDelegate* delegate1 = [[PWTestDelegate alloc] init];
	
	PWTest2Delegate* delegate2 = [[PWTest2Delegate alloc] init];
	
	[_delegate addDelegate:delegate1];
	
	[_delegate addDelegate:delegate2];
	
	[_delegate invokeSelector:@selector(methodWithInput1:input2:) withParameters:@[@"a", @"b"]];
	
	STAssertTrue(counter == 2, @"delegate object's method should be called twice");
}


@end
