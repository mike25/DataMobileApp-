//
//  MyLocationManager.m
//  DataMobile
//
//  Created by Kim Sawchuk on 11-11-28.
//  Copyright (c) 2011 MML-Concordia. All rights reserved.
//

#import "MyLocationManager.h"
#import "Config.h"

@implementation MyLocationManager

@synthesize manager;
@synthesize myDelegate;

- (void)startManagerWithDelegate:(id)delegate
           stopUpdatingAfterDays:(NSInteger)numOfDays
{
    manager = [[CLLocationManager alloc] init];
    [manager setDesiredAccuracy:[[Config instance] integerValueForKey:@"Accuracy"]];
    manager.distanceFilter = [[Config instance] integerValueForKey:@"distanceFilter"];
    manager.purpose = @"Do you want me to record your GPS Location ?" ;    
    manager.delegate = delegate;
    //myDelegate  = delegate ;
            
    [manager startUpdatingLocation];
}

- (void)stopManager
{    
    manager.delegate = nil;
   [manager stopUpdatingLocation];

    manager = nil;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ManagerDidStopUpdatingLocation" 
                                                        object:self];
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation 
           fromLocation:(CLLocation *)oldLocation
{
    [myDelegate locationManager:manager 
            didUpdateToLocation:newLocation 
                   fromLocation:oldLocation];
    [self.manager stopUpdatingLocation];
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
        [myDelegate locationManager:manager 
                   didFailWithError:error];
    }

    
}

@end
