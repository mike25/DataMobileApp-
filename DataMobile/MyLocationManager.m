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
@synthesize repeatingTimer;

- (void)startManagerWithDelegate:(id)delegate
{
    manager = [[CLLocationManager alloc] init];
    [manager setDesiredAccuracy:[[Config instance] integerValueForKey:@"Accuracy"]];
    manager.distanceFilter = [[Config instance] integerValueForKey:@"distanceFilter"];
    manager.purpose = @"Do you want me to record your GPS Location ?" ;    
    manager.delegate = delegate;
    
    [manager startUpdatingLocation];
    /*repeatingTimer = [NSTimer scheduledTimerWithTimeInterval:5
                                     target:manager
                                   selector:@selector(startUpdatingLocation) 
                                   userInfo:nil
                                    repeats:YES];*/
}

- (void)stopManager
{

    [repeatingTimer invalidate];
    manager.delegate = nil;
    [manager stopUpdatingLocation];
        
    self.manager = nil;
    repeatingTimer = nil;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ManagerDidStopUpdatingLocation" 
                                                        object:self];
}

@end
