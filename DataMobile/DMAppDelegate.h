//
//  DMAppDelegate.h
//  DataMobile
//
//  Created by Kim Sawchuk on 11-11-25.
//  Copyright (c) 2011 MML-Concordia. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LocationManagerHandler;
@class CLLocation;

@interface DMAppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong, nonatomic) LocationManagerHandler* managerHandler;
@property (strong, nonatomic) CLLocationManager* locationManager;

- (void)startUpdatingLocationsForDays:(NSInteger)numOfDays;
- (void)stopUpdatingLocations;

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

- (void) deleteAllLocations;

- (NSArray*)fetchAllUsers;

- (NSFetchRequest*)fetchAllObjects:(NSString *)entityName;
- (void) deleteAllObjects:(NSString *) entityName;

- (void)saveContext;        
- (NSURL *)applicationDocumentsDirectory;


@end
