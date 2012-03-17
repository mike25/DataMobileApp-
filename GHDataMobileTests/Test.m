//
//  Test.m
//  DataMobile
//
//  Created by Zachary Patterson on 3/16/12.
//  Copyright (c) 2012 MML-Concordia. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h> 

@interface Test : NSObject
@end

@interface MyTest : GHTestCase { }
@end

@implementation MyTest

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
