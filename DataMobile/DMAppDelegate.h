//
//  DMAppDelegate.h
//  DataMobile
//
//  Created by Kim Sawchuk on 11-11-25.
//  Copyright (c) 2011 MML-Concordia. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyLocationManager;
@class CLLocation;

@interface DMAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)insertLocation:(CLLocation*)newLocation;

- (void)insertUserWithId:(NSString*)uuid;

- (NSArray*)fetchAllLocations;
- (void) deleteAllLocations;

- (NSArray*)fetchAllObjects:(NSString *)entityName;
- (void) deleteAllObjects:(NSString *) entityName;

- (void)saveContext;        
- (NSURL *)applicationDocumentsDirectory;


@end
