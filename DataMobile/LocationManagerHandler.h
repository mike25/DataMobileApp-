//
//  MyLocationManager.h
//  DataMobile
//
//  Created by Kim Sawchuk on 11-11-28.
//  Copyright (c) 2011 MML-Concordia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationManagerHandler : NSObject

@property (weak, nonatomic) id myDelegate;
@property (weak,  nonatomic) CLLocationManager* locationManager;

- (void)locationManager:(CLLocationManager *)manager 
       didFailWithError:(NSError *)error;

- (void)managerDidUpdate;

- (void)applicationDidEnterBackground;

- (void)startManager:(CLLocationManager*)NewManager
        WithDelegate:(id)delegate 
           stopUpdatingAfterDays:(NSInteger)numOfDays;

- (void)stopManager;

@end
