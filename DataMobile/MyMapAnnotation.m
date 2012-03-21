//
//  MyMapAnnotation.m
//  DataMobile
//
//  Created by Zachary Patterson on 3/20/12.
//  Copyright (c) 2012 MML-Concordia. All rights reserved.
//

#import "MyMapAnnotation.h"

@implementation MyMapAnnotation

@synthesize object;
@synthesize name;

-(MyMapAnnotation*)initWithObject:(NSManagedObject *)managedObject
{
    return [[MyMapAnnotation alloc] initWithObject:managedObject WithName:@""];
}

-(MyMapAnnotation*)initWithObject:(NSManagedObject *)managedObject WithName:(NSString *)annotationName
{
    self = [super init];
    if (self != nil)
    {
        [self setObject:managedObject];
        [self setName:annotationName];
    }
    
    return self;
}

+(NSArray*)initFromArray:(NSArray*)managedObjects
{
    NSMutableArray *newArray = [[NSMutableArray alloc] initWithCapacity:[managedObjects count]];
    
    for (NSManagedObject* obj in managedObjects) 
    {
        MyMapAnnotation *annotation = [[MyMapAnnotation alloc] initWithObject:obj];
        [newArray addObject:annotation];
    }
    
    return newArray;
}

- (NSString *)title {
	return self.name;
}

- (NSString *)subtitle {
	return @"";
}

- (CLLocationCoordinate2D)coordinate
{
    return CLLocationCoordinate2DMake([[self.object valueForKey:@"latitude"] doubleValue], 
                                      [[self.object valueForKey:@"longitude"] doubleValue]);
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate
{
    // No need to implement.
}

@end
