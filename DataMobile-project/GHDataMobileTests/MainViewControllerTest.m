//
//  MainViewControllerTest.m
//  DataMobile
//
//  Created by Zachary Patterson on 3/21/12.
//  Copyright (c) 2012 MML-Concordia. All rights reserved.
//


#import "MainViewController.h"
#import "AlertViewManager.h"
#import "DMAppDelegateStub.h"
#import "CoreDataHelper.h"
#import "LocationManagerHandler.h"
#import "DMAppDelegateStub.h"

@interface MainViewControllerTest : GHTestCase

@property (strong,nonatomic) MainViewController* controller;
@property (weak,nonatomic) DMAppDelegateStub* appStub;

@end

@implementation MainViewControllerTest

@synthesize controller;
@synthesize appStub;

- (void)setUpClass
{
    appStub = [[UIApplication sharedApplication] delegate];
    
}

- (void)setUp
{
    [super setUp];
            
    controller = [[MainViewController alloc] initWithNibName:@"MainViewController"
                                                      bundle:nil];
    appStub.mockManagerHandler = [OCMockObject mockForClass:[LocationManagerHandler class]];
    appStub.mockCDataHelper = [OCMockObject mockForClass:[CoreDataHelper class]];
    
    [[[appStub.mockCDataHelper stub] 
      andReturn:[NSArray arrayWithObjects:nil]] fetchLocationsFromPosition:0 
                                                                     limit:1];
    
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
    id mock_error = [OCMockObject mockForClass:[NSError class]];
    [[[mock_error stub] andReturn:@"Error 1"] localizedDescription];    
    NSDictionary *dico = [NSDictionary dictionaryWithObjectsAndKeys:mock_error, @"error", nil];
    
    // Preventing the controller from showing the error message if the test passes.
    id mockAlertManager = [OCMockObject mockForClass:[AlertViewManager class]];
    [[[mockAlertManager stub] andReturn:nil] createErrorAlertWithMessage:[mock_error localizedDescription]];    
    controller.alertManager = mockAlertManager;
    
    GHAssertNoThrow([[NSNotificationCenter defaultCenter] postNotificationName:@"ManagerDidFailWithError" 
                                                                            object:appStub.managerHandler 
                                                                          userInfo:dico],
                    @"Posting a ManagerDidFailWithError notice should not throw exceptions");
    
}

@end
