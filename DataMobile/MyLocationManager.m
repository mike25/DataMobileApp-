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
@synthesize repeatingTimer;

- (void)startManagerWithDelegate:(id)delegate
{
    UIApplication *app = [UIApplication sharedApplication];
    
    UIBackgroundTaskIdentifier bgTask = [app beginBackgroundTaskWithExpirationHandler:^{ 
        [app endBackgroundTask:bgTask];
    }];
    
    self.manager = [[CLLocationManager alloc] init];
    [self.manager setDesiredAccuracy:[[Config instance] integerValueForKey:@"Accuracy"]];
    self.manager.distanceFilter = [[Config instance] integerValueForKey:@"distanceFilter"];
    self.manager.purpose = @"Do you want me to record your GPS Location ?" ;
    self.manager.delegate = delegate;
    
    repeatingTimer = [NSTimer scheduledTimerWithTimeInterval:300 
                                     target:manager
                                   selector:@selector(startUpdatingLocation) 
                                   userInfo:nil
                                    repeats:YES];
    
    [self.manager startUpdatingLocation];
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
