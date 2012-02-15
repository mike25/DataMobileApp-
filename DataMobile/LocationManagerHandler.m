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

- (void)startManager:(CLLocationManager*)NewManager
        WithDelegate:(id)delegate 
stopUpdatingAfterDays:(NSInteger)numOfDays
{
    locationManager = NewManager ;
    [locationManager setDesiredAccuracy:[[Config instance] integerValueForKey:@"Accuracy"]];
    locationManager.distanceFilter = [[Config instance] integerValueForKey:@"distanceFilter"];
    locationManager.purpose = @"Do you want me to record your GPS Location ?" ;
    locationManager.delegate = delegate;
    //myDelegate  = delegate ;
    
    [locationManager startUpdatingLocation];
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ManagerDidUpdateLocation" 
                                                        object:self];
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
    locationManager = nil;    
}

@end
