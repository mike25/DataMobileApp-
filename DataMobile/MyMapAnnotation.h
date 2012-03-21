//
//  MyMapAnnotation.h
//  DataMobile
//
//  Created by Zachary Patterson on 3/20/12.
//  Copyright (c) 2012 MML-Concordia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MyMapAnnotation : NSObject <MKAnnotation>

@property (strong, nonatomic) NSManagedObject* object;
@property (strong, nonatomic) NSString * name;

-(MyMapAnnotation*)initWithObject:(NSManagedObject *)managedObject;
-(MyMapAnnotation*)initWithObject:(NSManagedObject *)managedObject WithName:(NSString*)name;

/**
 *  returns an array of MyMapAnnotation from the passed array of NSManagedObject
 */
+(NSArray*)initFromArray:(NSArray*)managedObjects;

@end
