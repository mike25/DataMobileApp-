//
//  CoreDataHelper.h
//  DataMobile
//
//  Created by Zachary Patterson on 3/19/12.
//  Copyright (c) 2012 MML-Concordia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoreDataHelper : NSObject


@property (strong, nonatomic) NSURL* storeURL;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (id)initWithURL:(NSURL*)url;

- (void)insertLocation:(CLLocation*)newLocation;
- (void)insertNewUserIfNotExists;

/**
 * Returns All Location in TimeStamp Ascending order
 */
- (NSArray*)fetchAllLocations;

/**
 * Returns *count* Locations from position no *numberOfLocations*
 */
- (NSArray*)fetchLocationsFromPosition:(NSInteger)offset 
                                 limit:(NSInteger)limit;

- (NSArray*)fetchLocationsFromDate:(NSDate*)startDate 
                            ToDate:(NSDate*)endDate;

- (void) deleteAllLocations;

- (NSArray*)fetchAllUsers;

- (NSFetchRequest*)fetchAllObjects:(NSString *)entityName;
- (void) deleteAllObjects:(NSString *) entityName;

- (void)saveContext;        


@end
