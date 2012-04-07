//
//  DMMapViewTest.m
//  DataMobile
//
//  Created by Zachary Patterson on 4/6/12.
//  Copyright (c) 2012 MML-Concordia. All rights reserved.
//

#import "DMMapView.h"

@interface DMMapViewTest : GHTestCase <NSXMLParserDelegate>

@property (strong,nonatomic) DMMapView* map;
@property (strong,nonatomic) NSMutableArray* locationFixture;
@property (strong,nonatomic) id mockParserDelegate;

@end

@implementation DMMapViewTest

@synthesize map;
@synthesize locationFixture;
@synthesize mockParserDelegate;

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

- (void)testLocationsToCoordinates
{
    /* creating the Location array fixture */
    locationFixture = [[NSMutableArray alloc] init];   
    NSString *path = [[NSBundle mainBundle] pathForResource:@"coordinates-fixture"
                                                     ofType:@"xml"];
    GHAssertNotNil(path, @"The path to the coordinates-fixture.xml could not be determined");
    
    NSData *xmlData = [[NSData alloc] initWithContentsOfFile:path];
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:xmlData];
    
    /* setting up the mock delegate */
    mockParserDelegate = [OCMockObject partialMockForObject:self];
    for (int i = 0 ; i < 163; i++)
    {
        [[[mockParserDelegate expect] andForwardToRealObject] parser:[OCMArg any] 
                                                     didStartElement:[OCMArg any] 
                                                        namespaceURI:[OCMArg any]
                                                       qualifiedName:[OCMArg any] 
                                                          attributes:[OCMArg any]];
    }    
    [parser setDelegate:mockParserDelegate];
    
    BOOL parseSucceeded = [parser parse];
    GHTestLog([[parser parserError] description]);
    GHAssertTrue(parseSucceeded, @"The parsing of the xml fixture file failed");
    [mockParserDelegate verify];
}

# pragma mark - NSXMLParserDelegate

- (void)parser:(NSXMLParser *)parser 
didStartElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qName
    attributes:(NSDictionary *)attributeDict
{
}

@end
