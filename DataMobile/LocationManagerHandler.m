//
//  MyLocationManager.m
//  DataMobile
//
//  Created by Kim Sawchuk on 11-11-28.
//  Copyright (c) 2011 MML-Concordia. All rights reserved.
//

#import "LocationManagerHandler.h"
#import "Config.h"

@interface LocationManagerHandler ()
{
    UIBackgroundTaskIdentifier bgTask;
}

- (void)haltManager;
- (void)dispatchRecordingThread;
- (BOOL)dateExpired;

@end

@implementation LocationManagerHandler

static int currentTask = 0 ;

@synthesize locationManager;
@synthesize myDelegate;
@synthesize stopDate;
@synthesize recording;

- (void)startWithDelegate:(id<CLLocationManagerDelegate>)delegate 
    stopUpdatingAfterDays:(NSInteger)numOfDays
{        
    // Configuring Manager    
    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDesiredAccuracy:[[Config instance] integerValueForKey:@"Accuracy"]];
    locationManager.distanceFilter = [[Config instance] integerValueForKey:@"distanceFilter"];
    locationManager.purpose = @"Do you want me to record your GPS Location ?" ;    
    locationManager.delegate = self;
    
    [self setMyDelegate:delegate];
    stopDate = [[NSDate alloc] initWithTimeIntervalSinceNow:numOfDays*3600*24];
    
    UIApplication *app = [UIApplication sharedApplication]; 
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillEnterForeground) 
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:app];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidEnterBackground) 
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:app];
    
    [self dispatchRecordingThread];
}

- (void)haltManager
{
    locationManager.delegate = nil;
    [locationManager stopUpdatingLocation];
    locationManager = nil;
}

- (void)stopManager
{    
    if (bgTask) 
    {
        UIApplication* app = [UIApplication sharedApplication];
        [app endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;        
        
        [self haltManager];
        currentTask++;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ManagerDidStopUpdatingLocation"
                                                            object:self];
    }
}

- (void)locationManager:(CLLocationManager *)manager 
    didUpdateToLocation:(CLLocation *)newLocation 
           fromLocation:(CLLocation *)oldLocation
{
    [self.myDelegate locationManager:manager 
                 didUpdateToLocation:newLocation 
                        fromLocation:oldLocation];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ManagerDidUpdateLocation"
                                                        object:self];
    [manager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager 
       didFailWithError:(NSError *)error
{
    if ([error domain] == kCLErrorDomain && [error code] == 0) 
    {
        [manager startUpdatingLocation];
    }
    else
    {
        [self haltManager];
        NSDictionary* dico = [[NSDictionary alloc] initWithObjectsAndKeys:@"error", error, nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ManagerDidFailWithError"
                                                            object:self
                                                          userInfo:dico];
    }
}

- (void)applicationDidEnterBackground
{
}

- (void)applicationWillEnterForeground
{

}

- (void)dispatchRecordingThread
{
    
    /* Dispatch new recording thread */
    UIApplication* app = [UIApplication sharedApplication];
	
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        
        // TODO : implement expiration handler.
        
        [app endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
 
        int taskID = currentTask ;
        
        while (![self dateExpired] && taskID == currentTask)
        {
            if (myDelegate != nil)
            {
                [locationManager startUpdatingLocation];
            }            
            [NSThread sleepForTimeInterval:(POLLINTERVALSECONDS)];
        }		        
        
        if ([self dateExpired])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ManagerDidStopUpdatingLocation"
                                                                object:self];
            currentTask++;
        }
        
        [app endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    });
}

- (BOOL)dateExpired
{
    return [stopDate timeIntervalSinceNow] <= 0 ;
}

@end
