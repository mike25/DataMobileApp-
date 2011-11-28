//
//  MyLocationManager.m
//  DataMobile
//
//  Created by Kim Sawchuk on 11-11-28.
//  Copyright (c) 2011 MML-Concordia. All rights reserved.
//

#import "MyLocationManager.h"

@implementation MyLocationManager

@synthesize manager;
@synthesize observers;

- (MyLocationManager*)init
{
    self = [super init];
    if (self) 
    {
        observers = [[NSMutableArray alloc] initWithCapacity:2];
    }
    return self;
}

- (void)startManager
{
    self.manager = [[CLLocationManager alloc] init];
    [self.manager setDelegate:self];
    [self.manager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    [self.manager setDistanceFilter:DISTANCEFILTER];
    self.manager.purpose = @"Do you want me to record your GPS Location ?" ;
    
    [self.manager startUpdatingLocation];
    [self notifyObserversForStartAction];
}

- (void)stopManager
{
    [self.manager stopUpdatingLocation];
    self.manager = nil;
    [self notifyObserversForStopAction];
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation 
           fromLocation:(CLLocation *)oldLocation
{
    [self notifyObserversForUpdateActionWithLocation:newLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [self notifyObserversForFailActionWithError:error];
}



- (void)notifyObserversForStartAction
{
    for (id<MyLocationManagerObserver> observer in observers) 
    {
        if ([observer respondsToSelector:@selector(managerStarted)])
        {
            [observer managerStarted];
        }
    }
}

- (void)notifyObserversForStopAction
{
    for (id<MyLocationManagerObserver> observer in observers) 
    {
        if ([observer respondsToSelector:@selector(managerStopped)])
        {
            [observer managerStopped];
        }
    }
}

- (void)notifyObserversForUpdateActionWithLocation:(CLLocation *)newLocation
{
    for (id<MyLocationManagerObserver> observer in observers) 
    {
        if ([observer respondsToSelector:@selector(didUpdateToLocation:)])
        {
            [observer didUpdateToLocation:newLocation];
        }
    }
}

- (void)notifyObserversForFailActionWithError:(NSError *)error
{
    for (id<MyLocationManagerObserver> observer in observers) 
    {
        if ([observer respondsToSelector:@selector(didFailWithError:)])
        {
            [observer didFailWithError:error];
        }
    }
}


@end
