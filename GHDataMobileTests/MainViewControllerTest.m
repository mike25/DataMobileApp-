//
//  MainViewControllerTest.m
//  DataMobile
//
//  Created by Zachary Patterson on 3/21/12.
//  Copyright (c) 2012 MML-Concordia. All rights reserved.
//

#import "MainViewController.h"
#import "DMAppDelegate.h"

@interface MainViewControllerTest : GHTestCase

@property (strong,nonatomic) MainViewController* controller;

@end

@implementation MainViewControllerTest

@synthesize controller;

- (void)setUp
{
    [super setUp];
    
    //Creating a mock appDelegate object:
    id mockAppDelegate = [OCMockObject mockForClass:[DMAppDelegate class]];
        
    controller = [[MainViewController alloc] initWithNibName:@"MainViewController" 
                                                      bundle:nil];     
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testAppDelegate
{
    assertThat([controller appDelegate], is([[UIApplication sharedApplication] delegate]));
    
    GHAssertEquals([[[controller appDelegate] class] description],
                   @"DMAppDelegate",
                   @"");
}

- (void)testManagerDidFailWithError
{

}

@end
