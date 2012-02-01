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

@synthesize significant;

- (void)startManagerWithDelegate:(id)delegate
           stopUpdatingAfterDays:(NSInteger)numOfDays
{
    manager = [[CLLocationManager alloc] init];
    [manager setDesiredAccuracy:[[Config instance] integerValueForKey:@"Accuracy"]];
    manager.distanceFilter = [[Config instance] integerValueForKey:@"distanceFilter"];
    manager.purpose = @"Do you want me to record your GPS Location ?" ;    
    manager.delegate = delegate;
    
    repeatingTimer = [NSTimer scheduledTimerWithTimeInterval:20
                                     target:manager
                                   selector:@selector(startUpdatingLocation) 
                                   userInfo:nil
                                    repeats:YES];    

    
    // Defining a Timer to stop recording after x seconds has passed.
    [NSTimer scheduledTimerWithTimeInterval:numOfDays*3600*24
                                     target:self
                                   selector:@selector(stopManager) 
                                   userInfo:nil 
                                    repeats:NO];
    
    significant = NO;
    [manager startUpdatingLocation];
}

- (void)stopManager
{

    [repeatingTimer invalidate];
    repeatingTimer = nil;
    
    manager.delegate = nil;
   [manager stopMonitoringSignificantLocationChanges];
   [manager stopUpdatingLocation];

    manager = nil;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ManagerDidStopUpdatingLocation" 
                                                        object:self];
}

- (void)update
{
    [manager stopMonitoringSignificantLocationChanges];
    significant = NO;
    [manager startUpdatingLocation];
    
    NSLog(@"update called");

}

-(void)print
{
    NSLog(@"print");
}

@end
