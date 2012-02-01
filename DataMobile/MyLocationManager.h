//
//  MyLocationManager.h
//  DataMobile
//
//  Created by Kim Sawchuk on 11-11-28.
//  Copyright (c) 2011 MML-Concordia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyLocationManager : NSObject

@property (weak, nonatomic) id myDelegate;

@property (strong,  nonatomic) CLLocationManager* manager;
@property (strong, nonatomic) NSTimer* repeatingTimer;
@property (nonatomic) BOOL significant;

- (void)startManagerWithDelegate:(id)delegate 
           stopUpdatingAfterDays:(NSInteger)numOfDays;

- (void)stopManager;
- (void)update;
- (void)print;

@end
