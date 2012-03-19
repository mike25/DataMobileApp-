//
//  DMAppDelegateTest.m
//  DataMobile
//
//  Copyright (c) 2012 MML-Concordia. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h> 
#import <OCMock/OCMock.h>
#import "CoreDataHelper.h"

@interface DMAppDelegateTest : GHTestCase { }

@end

@implementation DMAppDelegateTest

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testStrings {       
    NSString *string1 = @"a string";
    GHTestLog(@"I can log to the GHUnit test console: %@", string1);
    
    // Assert string1 is not NULL, with no custom error description
    GHAssertNotNULL((__bridge void*)string1, nil);
    
    // Assert equal objects, add custom error description
    NSString *string2 = @"a string";
    GHAssertEqualObjects(string1, string2, @"A custom error message. string1 should be equal to: %@.", string2);
}



@end
