//
//  ArrayCustomizationTests.m
//  PassagewayServerMac
//
//  Created by Mark Sinkovics on 9/25/12.
//
//

#import "ArrayCustomizationTests.h"
#import "NSArray+Factory.h"
@implementation ArrayCustomizationTests

- (void)setUp
{
    [super setUp];

    array = [[PWWindowManager sharedManager] updateWindowList];
	
	NSLog(@"all : %@", array);
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testArrayCustomization
{
	NSArray* test = [array createCustomSubArrayUsedKeyPath:@"windowIDNumber"];
	
	STAssertEquals(test.count, array.count, @"Size is not equal!");
	
	NSLog(@"test : %@", test);
}

@end
