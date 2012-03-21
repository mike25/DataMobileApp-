//
//  MyMapAnnotationTest.h
//  DataMobile
//
//  Created by Zachary Patterson on 3/20/12.
//  Copyright (c) 2012 MML-Concordia. All rights reserved.
//

#import "MyMapAnnotation.h"

#define NUMBEROFOBJECTS 50

@interface MyMapAnnotationTest : GHTestCase

@property (strong, nonatomic) NSArray* managedObjects;

@end


@implementation MyMapAnnotationTest

@synthesize managedObjects;

- (void)setUp
{
    [super setUp];
    
    NSMutableArray* array = [[NSMutableArray alloc] initWithCapacity:NUMBEROFOBJECTS];
    for (int i = 0; i < NUMBEROFOBJECTS; i++) 
    {
        id mockManagedObject = [OCMockObject mockForClass:[NSManagedObject class]];
        
        NSNumber* num = [NSNumber numberWithInt:i];        
        [[[mockManagedObject stub] andReturn:num] valueForKey:@"latitude"];
        [[[mockManagedObject stub] andReturn:num] valueForKey:@"longitude"];
        
        [array insertObject:mockManagedObject atIndex:i];
    }
    
    self.managedObjects = array ;
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    managedObjects = nil;
        
    [super tearDown];
}

- (void)testInitWithObject
{    
    id mockManagedObject = [OCMockObject mockForClass:[NSManagedObject class]];
    
    NSNumber* num = [NSNumber numberWithInt:45];        
    [[[mockManagedObject stub] andReturn:num] valueForKey:@"latitude"];
    [[[mockManagedObject stub] andReturn:num] valueForKey:@"longitude"];
    
    MyMapAnnotation* note = [[MyMapAnnotation alloc] initWithObject:mockManagedObject];
    
    HC_assertThatDouble(note.coordinate.latitude, equalToDouble(45));
}

- (void)testInitFromArray
{
    NSArray* outputArray = [MyMapAnnotation initFromArray:self.managedObjects];
    
    GHAssertTrue([outputArray count] == NUMBEROFOBJECTS, @"The size of the two arrays should be the same");
    
    GHAssertEqualObjects([[outputArray objectAtIndex:5] class], 
                         [MyMapAnnotation class],
                         @"the output array's objects should be of type MyMapAnnotation.");
    GHAssertEqualObjects([[outputArray objectAtIndex:3] name]
                         , @""
                         , @"the output array's objects name should be empty.");
    
    MyMapAnnotation* note = (MyMapAnnotation*)[outputArray objectAtIndex:2];
    GHAssertNoThrow([note coordinate], @"the arrays objects attribute should not throw exceptions");
    HC_assertThatDouble(note.coordinate.latitude, equalToDouble(2));
    HC_assertThatDouble(note.coordinate.longitude, equalToDouble(2));
}

@end
