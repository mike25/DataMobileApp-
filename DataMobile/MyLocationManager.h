//
//  MyLocationManager.h
//  DataMobile
//
//  Created by Kim Sawchuk on 11-11-28.
//  Copyright (c) 2011 MML-Concordia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyLocationManager : NSObject <CLLocationManagerDelegate>

@property (weak, nonatomic) id<CLLocationManagerDelegate> myDelegate;
@property (strong,  nonatomic) CLLocationManager* manager;

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation 
           fromLocation:(CLLocation *)oldLocation;

- (void)locationManager:(CLLocationManager *)manager 
       didFailWithError:(NSError *)error;

- (void)startManagerWithDelegate:(id)delegate 
           stopUpdatingAfterDays:(NSInteger)numOfDays;

- (void)stopManager;
@end
