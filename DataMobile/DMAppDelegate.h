//
//  DMAppDelegate.h
//  DataMobile
//
//  Created by Kim Sawchuk on 11-11-25.
//  Copyright (c) 2011 MML-Concordia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyLocationManager.h"

@interface DMAppDelegate : UIResponder <UIApplicationDelegate, MyLocationManagerObserver>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)managerStopped;
- (void)didUpdateToLocation:(CLLocation *)newLocation;
- (void)didFailWithError:(NSError *)error;

- (NSArray*)fetchAllLocations;
- (void) deleteAllLocations;

- (NSArray*)fetchAllObjects:(NSString *)entityName;
- (void) deleteAllObjects:(NSString *) entityName;

- (void)saveContext;        
- (NSURL *)applicationDocumentsDirectory;


@end
