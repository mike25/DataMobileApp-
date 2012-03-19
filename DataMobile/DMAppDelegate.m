//
//  DMAppDelegate.m
//  DataMobile
//
//  Created by Kim Sawchuk on 11-11-25.
//  Copyright (c) 2011 MML-Concordia. All rights reserved.
//

#import "DMAppDelegate.h"
#import "LocationManagerHandler.h"
#import "CoreDataHelper.h"

@interface DMAppDelegate()
@end

@implementation DMAppDelegate

UIBackgroundTaskIdentifier bgTask;
BOOL inBackground;

@synthesize window = _window;
@synthesize cdataHelper;

@synthesize managerHandler;

- (id)init
{
    if (self = [super init]) 
    {
        cdataHelper = [[CoreDataHelper alloc] 
                         initWithURL:[[self applicationDocumentsDirectory] 
                                    URLByAppendingPathComponent:@"DataMobile.sqlite"]];
    }
    return self;
}

- (void)startUpdatingLocationsForDays:(NSInteger)numOfDays
{
    managerHandler = [[LocationManagerHandler alloc] init];
    
    [managerHandler startWithDelegate:self 
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
    [cdataHelper insertLocation:newLocation];
}

- (void)insertNewUserIfNotExists
{        
    [cdataHelper insertNewUserIfNotExists];
}

- (NSArray*)fetchAllLocations
{
    return [cdataHelper fetchAllLocations];
}

- (NSArray*)fetchLocationsFromPosition:(NSInteger)offset 
                                 limit:(NSInteger)limit
{
    return [cdataHelper fetchLocationsFromPosition:offset 
                                             limit:limit];
}

- (NSArray*)fetchLocationsFromDate:(NSDate*)startDate 
                            ToDate:(NSDate*)endDate
{
    return [cdataHelper fetchLocationsFromDate:startDate 
                                        ToDate:endDate];
}

- (void)deleteAllLocations
{
    [cdataHelper deleteAllLocations];
}

- (NSArray*)fetchAllUsers
{
    return [cdataHelper fetchAllUsers];
}

- (NSFetchRequest*)fetchAllObjects:(NSString *)entityName
{
    return [cdataHelper fetchAllObjects:entityName];
}

- (void)deleteAllObjects:(NSString*)entityName  
{
    [cdataHelper deleteAllObjects:entityName];
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
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
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
    [cdataHelper saveContext];
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
