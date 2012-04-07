//
//  DMMapViewTest.m
//  DataMobile
//
//  Created by Zachary Patterson on 4/6/12.
//  Copyright (c) 2012 MML-Concordia. All rights reserved.
//

#import "DMMapView.h"
#import "TBXML.h"

@interface DMMapViewTest : GHTestCase <NSXMLParserDelegate>
{
    BOOL captureCharacters;
}

@property (strong,nonatomic) DMMapView* map;
@property (strong,nonatomic) NSMutableArray* locationFixture;

// NOTE : Trying to create a partial mock delegate is not feasible
// due to the current (lack of) features of the OCMock Library.
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
    [parser setDelegate:self];
    captureCharacters = NO;
    BOOL parseSucceeded = [parser parse];
    GHAssertTrue(parseSucceeded, @"The parsing of the xml fixture file failed");
    
    
}

# pragma mark - NSXMLParserDelegate

- (void)parser:(NSXMLParser *)parser 
didStartElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qName
    attributes:(NSDictionary *)attributeDict
{
    if([elementName isEqualToString:@"column"])
    {
        captureCharacters = YES;        
    }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{

}

-(void)parser:(NSXMLParser *)parser 
didEndElement:(NSString *)elementName 
 namespaceURI:(NSString *)namespaceURI
qualifiedName:(NSString *)qName
{

}

@end
