//
//  MainViewControllerTest.m
//  DataMobile
//
//  Created by Zachary Patterson on 3/21/12.
//  Copyright (c) 2012 MML-Concordia. All rights reserved.
//

#import "MainViewController.h"
#import "MainViewControllerTest.h"
#import "DMAppDelegateStub.h"

@implementation MainViewControllerTest

@synthesize controller;

- (void)setUp
{
    [super setUp];
        
    DMAppDelegateStub* appStub = [[UIApplication sharedApplication] delegate];
    
    controller = [[MainViewController alloc] initWithNibName:@"MainViewController"
                                                      bundle:nil];
    [controller viewDidLoad];
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
}

- (void)testManagerDidFailWithError
{

}

@end
