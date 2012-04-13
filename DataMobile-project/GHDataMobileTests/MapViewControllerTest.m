//
//  MapViewControllerTest.m
//  DataMobile
//
//  Created by Zachary Patterson on 3/28/12.
//  Copyright (c) 2012 MML-Concordia. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "MapViewController.h"
#import "DMAppDelegateStub.h"
#import "CoreDataHelper.h"

@interface MapViewControllerTest : GHTestCase

@property (strong,nonatomic) MapViewController* mapCtrl;
@property (weak,nonatomic) DMAppDelegateStub* appStub;

@end

@implementation MapViewControllerTest

@synthesize appStub;
@synthesize mapCtrl;

- (void)setUp
{
    [super setUp];

    appStub.mockCDataHelper = [OCMockObject mockForClass:[CoreDataHelper class]];
    mapCtrl = [[MapViewController alloc] initWithNibName:@"MapViewController" 
                                                  bundle:nil];
    [mapCtrl viewDidLoad];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

/**
 * Assert that if there are two or more recordings that are 
 * both close in time and space, only one of that group is shown 
 * on the map
 */
- (void)testDrawingDoesNotBloatTheMap
{
    /* creating coordinates fixture */
    NSMutableArray* locations = [NSMutableArray arrayWithCapacity:100];
    
    // TODO : add logic to add coordinates.
        
    
}

@end
