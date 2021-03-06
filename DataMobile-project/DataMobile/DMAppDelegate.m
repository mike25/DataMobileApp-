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

#if RUN_KIF_TESTS
    #import "DataMBTestController.h"
#endif

@interface DMAppDelegate()

- (NSURL *)applicationDocumentsDirectory;

@end

@implementation DMAppDelegate

UIBackgroundTaskIdentifier bgTask;
BOOL inBackground;

@synthesize window = _window;

@synthesize cdataHelper;
@synthesize managerHandler;

- (void)startUpdatingLocationsForDays:(NSInteger)numOfDays
{
    managerHandler = [[LocationManagerHandler alloc] init];
    
    [managerHandler startWithDelegate:self 
                stopUpdatingAfterDays:numOfDays];
}

- (void)stopUpdatingLocations
{
    [managerHandler stopManager];
    [cdataHelper saveContext];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation 
           fromLocation:(CLLocation *)oldLocation
{
    [cdataHelper insertLocation:newLocation];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSString *cdataPath = [[[self applicationDocumentsDirectory] path] stringByAppendingPathComponent:@"DataMobile.sqlite"];
    NSURL *cdataUrl = [NSURL fileURLWithPath:cdataPath];
    
#if RUN_KIF_TESTS    
    // Load Fixture Database
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:cdataPath]) 
    {
        NSString *fixtureStorePath = [[NSBundle mainBundle] pathForResource:@"DataMobile" 
                                                                     ofType:@"sqlite"];
        if (fixtureStorePath) 
        {
            [fileManager copyItemAtPath:fixtureStorePath 
                                 toPath:cdataPath
                                  error:NULL];
        }
    }    
#endif
        
    cdataHelper = [[CoreDataHelper alloc] initWithURL:cdataUrl];
 
    [cdataHelper insertNewUserIfNotExists];
    
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
    [cdataHelper saveContext];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
#if RUN_KIF_TESTS
    [[DataMBTestController sharedInstance] startTestingWithCompletionBlock:^{
        // Exit after the tests complete so that CI knows we're done
        exit([[DataMBTestController sharedInstance] failureCount]);
    }];
#endif

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
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
