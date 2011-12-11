//
//  TestTest.m
//  DataMobile
//
//  Created by Kim Sawchuk on 11-12-08.
//  Copyright (c) 2011 MML-Concordia. All rights reserved.
//

#import "TestTest.h"

#import <UIKit/UIKit.h>
//#import "application_headers" as required

@implementation TestTest

// All code under test is in the iOS Application
- (void)testAppDelegate
{
    id yourApplicationDelegate = [[UIApplication sharedApplication] delegate];
    STAssertNotNil(yourApplicationDelegate, @"UIApplication failed to find the AppDelegate");
}

- (void)setUp {
    // Run before each test method
}

- (void)tearDown {
    // Run after each test method
}


@end
