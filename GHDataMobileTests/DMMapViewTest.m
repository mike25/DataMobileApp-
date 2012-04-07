//
//  DMMapViewTest.m
//  DataMobile
//
//  Created by Zachary Patterson on 4/6/12.
//  Copyright (c) 2012 MML-Concordia. All rights reserved.
//

#import "DMMapView.h"
#import "TBXML.h"
#import "MyMapAnnotation.h"

@interface DMMapViewTest : GHTestCase

@property (strong,nonatomic) DMMapView* map;
@property (strong,nonatomic) NSMutableArray* locationFixture;


@end

@implementation DMMapViewTest

@synthesize map;
@synthesize locationFixture;

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

- (void)setUpTestLocationToCoordinates
{
    /* creating the Location array fixture */
    locationFixture = [[NSMutableArray alloc] init];   
    NSString *path = [[NSBundle mainBundle] pathForResource:@"coordinates-fixture"
                                                     ofType:@"xml"];
    GHAssertNotNil(path, @"The path to the coordinates-fixture.xml could not be determined");        
    
    /* Load and parse the fixture file */
    NSData *xmlData = [[NSData alloc] initWithContentsOfFile:path];
    NSError *error = nil;    
	TBXML* tbxml = [TBXML tbxmlWithXMLData:xmlData error:&error];    
    GHAssertFalse(error, @"Error during parsing of the xml file");
    
    TBXMLElement* tableElement = tbxml.rootXMLElement->firstChild->firstChild;
    do 
    {
        NSString* latitude;
        NSString* longitude;
        NSString* timeStamp;
        
        TBXMLElement* columnElement = tableElement->firstChild;
        do 
        {
            if ([[TBXML valueOfAttributeNamed:@"name" forElement:columnElement] isEqualToString:@"ZLATITUDE"]) 
            {
                latitude = [TBXML textForElement:columnElement];
            }
            else if([[TBXML valueOfAttributeNamed:@"name" forElement:columnElement] isEqualToString:@"ZLONGITUDE"])
            {
                longitude = [TBXML textForElement:columnElement];
            }                        
        } while ((columnElement = columnElement->nextSibling));
        
        /* create MyMapAnnotation mock object */
        id mockManagedObject = [OCMockObject mockForClass:[NSManagedObject class]];
        [[[mockManagedObject stub] andReturn:(NSDate*)timeStamp] valueForKey:@"timestamp"];
        [[[mockManagedObject stub] andReturn:latitude] valueForKey:@"latitude"];
        [[[mockManagedObject stub] andReturn:longitude] valueForKey:@"longitude"];        
        MyMapAnnotation* annotation = [[MyMapAnnotation alloc] initWithObject:mockManagedObject];
        
        [locationFixture addObject:annotation];
        
    } while ((tableElement = tableElement->nextSibling));
    
    MyMapAnnotation* annotation = (MyMapAnnotation*)[locationFixture objectAtIndex:0];    
    HC_assertThatDouble(annotation.coordinate.longitude,
                        equalToDouble(-73.57760599768996));

}

- (void)testLocationsToCoordinates
{
    [self setUpTestLocationToCoordinates];
}


@end
