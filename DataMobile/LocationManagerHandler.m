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

- (void)haltManager;

@end

@implementation LocationManagerHandler

@synthesize locationManager;
@synthesize myDelegate;
@synthesize stopDate;

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
    [locationManager stopUpdatingLocation];
    [locationManager startUpdatingLocation];
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
