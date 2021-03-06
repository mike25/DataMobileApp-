//
//  MyLocationManager.h
//  DataMobile
//
//  Created by Kim Sawchuk on 11-11-28.
//  Copyright (c) 2011 MML-Concordia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationManagerHandler : NSObject <CLLocationManagerDelegate>

@property (weak, nonatomic) id<CLLocationManagerDelegate> myDelegate;
@property (strong, nonatomic) CLLocationManager* locationManager;

@property (strong, nonatomic) NSDate* stopDate;
@property (nonatomic) BOOL recording;

- (void)applicationDidEnterBackground;
- (void)applicationWillEnterForeground;

- (void)startWithDelegate:(id<CLLocationManagerDelegate>)delegate 
stopUpdatingAfterDays:(NSInteger)numOfDays;

- (void)stopManager;

@end
