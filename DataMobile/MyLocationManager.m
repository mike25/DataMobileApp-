//
//  MyLocationManager.m
//  DataMobile
//
//  Created by Kim Sawchuk on 11-11-28.
//  Copyright (c) 2011 MML-Concordia. All rights reserved.
//

#import "MyLocationManager.h"
#import "MyLocationManagerObserver.h"

@implementation MyLocationManager

@synthesize manager;
@synthesize observer;

- (void)startManagerWithDelegate:(id)delegate
{
    self.manager = [[CLLocationManager alloc] init];
    [self.manager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    [self.manager setDistanceFilter:DISTANCEFILTER];
    self.manager.purpose = @"Do you want me to record your GPS Location ?" ;
    
    self.manager.delegate = delegate;
    [self.manager startUpdatingLocation];
    [self.observer managerStarted];
}

- (void)stopManager
{
    [self.manager stopUpdatingLocation];
    self.manager = nil;
    [self.observer managerStopped];
}





@end
