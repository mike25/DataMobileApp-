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

- (void)setUpReduceLocations
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
        NSDate* timeStamp;
        
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
            else if([[TBXML valueOfAttributeNamed:@"name" forElement:columnElement] isEqualToString:@"ZTIMESTAMP"])
            {
                timeStamp = [NSDate dateWithTimeIntervalSince1970:[[TBXML textForElement:columnElement] 
                                                                   doubleValue]];                
            }        
        } while ((columnElement = columnElement->nextSibling));
        
        /* create MyMapAnnotation mock object */
        id mockManagedObject = [OCMockObject mockForClass:[NSManagedObject class]];
        [[[mockManagedObject stub] andReturn:timeStamp] valueForKey:@"timestamp"];
        [[[mockManagedObject stub] andReturn:latitude] valueForKey:@"latitude"];
        [[[mockManagedObject stub] andReturn:longitude] valueForKey:@"longitude"];        
        MyMapAnnotation* annotation = [[MyMapAnnotation alloc] initWithObject:mockManagedObject];
        
        [locationFixture addObject:annotation];
        
    } while ((tableElement = tableElement->nextSibling));

    /* testing that the data in the fixture and the array correspond. */
    MyMapAnnotation* annotation = (MyMapAnnotation*)[locationFixture objectAtIndex:0];    
    HC_assertThatDouble(annotation.coordinate.longitude,
                        equalToDouble(-73.57760599768996));
    HC_assertThatDouble(annotation.coordinate.latitude,
                        equalToDouble(45.49587642201236));
    NSDate* dateOfCoordinate1 = [NSDate dateWithTimeIntervalSince1970:354769326.97449];    
    GHAssertNotNil([annotation timeStamp], 
                   @"the TimeStamp fixture has not been set");
    GHAssertTrue([[annotation timeStamp] timeIntervalSinceDate:dateOfCoordinate1] == 0, @"");
    HC_assertThatInteger([locationFixture count], equalToInteger(163));
}

- (void)testReduceLocations
{
    [self setUpReduceLocations];
    
    NSArray* strippedLocations = [DMMapView reduceLocations:locationFixture];
    
    NSUInteger size = 5;
    
    GHAssertLessThanOrEqual([strippedLocations count], size, @"The array has not been reduced enough");
    GHTestLog(@"%i", [strippedLocations count]);
    
    for (MyMapAnnotation* note1 in strippedLocations)
    {
        for (MyMapAnnotation* note2 in strippedLocations) 
        {
            if(note1 != note2)
            {
                CLLocation* l1 = [[CLLocation alloc] initWithLatitude:note1.coordinate.latitude 
                                                            longitude:note1.coordinate.longitude];
                CLLocation* l2 = [[CLLocation alloc] initWithLatitude:note2.coordinate.latitude 
                                                            longitude:note2.coordinate.longitude];                                
                CLLocationDistance distance = [l1 distanceFromLocation:l2];
                NSTimeInterval timeInterval = abs([note1.timeStamp timeIntervalSinceDate:note2.timeStamp]);
                
                //GHTestLog(@"%f, %f", distance, timeInterval);
                GHAssertTrue( distance >= 100 || timeInterval >= 120,
                             @"The number of Locations has not been reduced properly. Distance is %f and TimeInterval is %f, should be distance > %f or TimeInterval > %f",
                             distance,
                             timeInterval,
                             100.0,
                             120.0);
            }        
        }
    }
}


@end
