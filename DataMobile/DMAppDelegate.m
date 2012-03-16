//
//  DMAppDelegate.m
//  DataMobile
//
//  Created by Kim Sawchuk on 11-11-25.
//  Copyright (c) 2011 MML-Concordia. All rights reserved.
//

#import "DMAppDelegate.h"
#import "LocationManagerHandler.h"

@interface DMAppDelegate()

- (NSFetchRequest*)getAllLocationsRequest;

/**
 * Fetches the passed request, ignoring the error.
 */
- (NSArray*)fetchRequest:(NSFetchRequest*)request;

@end

@implementation DMAppDelegate

UIBackgroundTaskIdentifier bgTask;
BOOL inBackground;

@synthesize window = _window;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;

@synthesize managerHandler;
@synthesize locationManager;

- (void)startUpdatingLocationsForDays:(NSInteger)numOfDays
{
    managerHandler = [[LocationManagerHandler alloc] init];
    locationManager = [[CLLocationManager alloc] init];
    
    [managerHandler startManager:locationManager 
                    WithDelegate:self 
           stopUpdatingAfterDays:numOfDays];    
}

- (void)stopUpdatingLocations
{
    [managerHandler stopManager];
    [self saveContext];
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation 
           fromLocation:(CLLocation *)oldLocation
{
    [self insertLocation:newLocation];
}

- (void)insertLocation:(CLLocation*)newLocation
{
    // Save new Location :
    NSManagedObject* location = [NSEntityDescription insertNewObjectForEntityForName:@"Location"
                                                              inManagedObjectContext:self.managedObjectContext];
    
    NSDictionary* locationDico = [[NSDictionary alloc] initWithObjectsAndKeys: 
                                  [NSNumber numberWithDouble:newLocation.altitude], @"altitude",
                                  [NSNumber numberWithDouble:newLocation.coordinate.longitude], @"longitude",
                                  [NSNumber numberWithDouble:newLocation.coordinate.latitude], @"latitude",
                                  [NSNumber numberWithDouble:newLocation.speed], @"speed",
                                  [NSNumber numberWithDouble:newLocation.course], @"direction",
                                  [NSNumber numberWithDouble:newLocation.horizontalAccuracy], @"h_accuracy",
                                  [NSNumber numberWithDouble:newLocation.verticalAccuracy], @"v_accuracy",
                                  newLocation.timestamp, @"timestamp",
                                  nil];
    [location setValuesForKeysWithDictionary:locationDico];
    
}

- (void)insertNewUserIfNotExists
{        
    if([[self fetchAllUsers] count] == 0)
    {
        // Generate new User Id
        CFUUIDRef UUIDRef = CFUUIDCreate(kCFAllocatorDefault);
        CFStringRef UUIDSRef = CFUUIDCreateString(kCFAllocatorDefault, UUIDRef);
        
        NSManagedObject* newUser = [NSEntityDescription insertNewObjectForEntityForName:@"User"
                                                                 inManagedObjectContext:self.managedObjectContext];
        
        [newUser setValue:[NSString stringWithFormat:@"%@", UUIDSRef] 
                   forKey:@"id"];
        
        [self saveContext];
    }
}

- (NSFetchRequest*)getAllLocationsRequest
{
    NSFetchRequest *request = [self fetchAllObjects:@"Location"];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"timestamp" ascending:YES];
    
    request.sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    return request;
}

- (NSArray*)fetchRequest:(NSFetchRequest*)request
{
    NSError *error;    
    return  [self.managedObjectContext executeFetchRequest:request
                                                     error:&error];
}

- (NSArray*)fetchAllLocations
{
    NSFetchRequest *request = [self getAllLocationsRequest];
    return [self fetchRequest:request];
}

- (NSArray*)fetchLocationsFromPosition:(NSInteger)offset 
                                 limit:(NSInteger)limit
{
    NSFetchRequest *request = [self getAllLocationsRequest];
    
    request.fetchOffset = offset;
    request.fetchLimit = limit;    
        
    return [self fetchRequest:request];
}
 
- (void)deleteAllLocations
{
    [self deleteAllObjects:@"Location"];
}

- (NSArray*)fetchAllUsers
{
    NSError* error;    
    return [self.managedObjectContext executeFetchRequest:[self fetchAllObjects:@"User"] 
                                                    error:&error];
}

- (NSFetchRequest*)fetchAllObjects:(NSString *)entityName
{
    [self saveContext];
    NSEntityDescription *eDescription = [NSEntityDescription
                                         entityForName:entityName 
                                         inManagedObjectContext:self.managedObjectContext]; 
    
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    request.entity = eDescription;

    return request;
}

- (void) deleteAllObjects: (NSString*)entityName  
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:__managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *items = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    for (NSManagedObject *managedObject in items) 
    {
        [self.managedObjectContext deleteObject:managedObject];
        // object deleted
    }
    if (![self.managedObjectContext save:&error]) 
    {
        // error deleting object
    }
    [self saveContext];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self insertNewUserIfNotExists];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
//    [managerHandler applicationDidEnterBackground];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
//    [managerHandler applicationWillEnterForeground];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil)
    {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil)
    {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"DataMobile" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil)
    {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"DataMobile.sqlite"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         */[[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
         /*
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
