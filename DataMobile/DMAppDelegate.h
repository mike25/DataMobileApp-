//
//  DMAppDelegate.h
//  DataMobile
//
//  Created by Kim Sawchuk on 11-11-25.
//  Copyright (c) 2011 MML-Concordia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyLocationManagerObserver.h"

@class MyLocationManager;

@interface DMAppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong, nonatomic) MyLocationManager* locationManager;

- (void)startManagerWithObserver:(id)observer;
- (void)stopLocationManager;

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation 
           fromLocation:(CLLocation *)oldLocation;

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error;

- (void)insertUserWithId:(NSString*)uuid;

- (NSArray*)fetchAllLocations;
- (void) deleteAllLocations;

- (NSArray*)fetchAllObjects:(NSString *)entityName;
- (void) deleteAllObjects:(NSString *) entityName;

- (void)saveContext;        
- (NSURL *)applicationDocumentsDirectory;


@end
