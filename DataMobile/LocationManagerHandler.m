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

@end

@implementation LocationManagerHandler

@synthesize locationManager;
@synthesize myDelegate;
@synthesize stopDate;
@synthesize inBackground;

- (void)startManager:(CLLocationManager*)manager
        WithDelegate:(id)delegate 
stopUpdatingAfterDays:(NSInteger)numOfDays
{    
    // Configuring Manager    
    locationManager = manager;
    [locationManager setDesiredAccuracy:[[Config instance] integerValueForKey:@"Accuracy"]];
    locationManager.distanceFilter = [[Config instance] integerValueForKey:@"distanceFilter"];
    locationManager.purpose = @"Do you want me to record your GPS Location ?" ;
    locationManager.delegate = delegate;
    
    [locationManager startUpdatingLocation];
    
    stopDate = [[NSDate alloc] initWithTimeIntervalSinceNow:numOfDays*3600*24];
}

- (void)stopManager
{    
    [self haltManager];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ManagerDidStopUpdatingLocation" 
                                                        object:self];
}

- (void)managerDidUpdate
{
    [self.locationManager stopUpdatingLocation];

    if ([stopDate timeIntervalSinceNow] <= 0)
    {
        [self stopManager];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ManagerDidUpdateLocation" 
                                                            object:self];
    }
}

- (void)applicationDidEnterBackground
{    
    inBackground = YES;
	UIApplication* app = [UIApplication sharedApplication];
	
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        [app endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }];
	
    // Start the long-running task and return immediately.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		while ([stopDate timeIntervalSinceNow] > 0) 
        {            
            [NSThread sleepForTimeInterval:(POLLINTERVALSECONDS)];
            [locationManager stopUpdatingLocation];
            [locationManager startUpdatingLocation];
		}		
        
        [app endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    });
}

- (void)applicationWillEnterForeground
{
    inBackground = NO;  
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

- (void)haltManager
{
    locationManager.delegate = nil;
    [locationManager stopUpdatingLocation];
    stopDate = nil ;
    locationManager = nil;    
}

@end
