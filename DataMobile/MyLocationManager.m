//
//  MyLocationManager.m
//  DataMobile
//
//  Created by Kim Sawchuk on 11-11-28.
//  Copyright (c) 2011 MML-Concordia. All rights reserved.
//

#import "MyLocationManager.h"
#import "MyLocationManagerObserver.h"
#import "Config.h"

@interface MyLocationManager ()

- (void)update;

@end

@implementation MyLocationManager

@synthesize manager;
@synthesize observer;
@synthesize myDelegate;

- (void)startManagerWithDelegate:(id)delegate
{
    self.manager = [[CLLocationManager alloc] init];
    [self.manager setDesiredAccuracy:[[Config instance] integerValueForKey:@"Accuracy"]];
    self.manager.distanceFilter = [[Config instance] integerValueForKey:@"distanceFilter"];
    self.manager.purpose = @"Do you want me to record your GPS Location ?" ;
    
    myDelegate = delegate;

    [self update];
    [NSTimer scheduledTimerWithTimeInterval:600 
                                     target:self
                                   selector:@selector(update) 
                                   userInfo:nil
                                    repeats:YES];     
    [self.observer managerStarted];
}

- (void)stopManager
{
    [self.manager stopUpdatingLocation];      
    self.manager = nil;
    
    [self.observer managerStopped];
}

- (void)update
{
    self.manager.delegate = myDelegate;
    [self.manager startUpdatingLocation];
}

@end
