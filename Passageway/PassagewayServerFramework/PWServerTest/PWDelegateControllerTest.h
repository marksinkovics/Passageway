//
//  PWDelegateControllerTest.h
//  PassagewayServerFramework
//
//  Created by Mark Sinkovics on 3/3/13.
//
//

#import <SenTestingKit/SenTestingKit.h>
#import "PWDelegateController.h"

@interface PWDelegateControllerTest : SenTestCase
{
	PWDelegateController* _delegate;
}

+ (void)increaseCounter;

@end

@protocol PWTestProtocol <NSObject>

- (void)sayGoodBye;

@end

@interface PWTestDelegate : NSObject<PWTestProtocol>

- (void)sayHello;

- (void)methodWithInput1:(NSString*)input1 input2:(NSString*)input2;

@end

@interface PWTest2Delegate : NSObject

- (void)sayHello;

- (void)methodWithInput1:(NSString*)input1 input2:(NSString*)input2;

@end

