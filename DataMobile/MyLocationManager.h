//
//  MyLocationManager.h
//  DataMobile
//
//  Created by Kim Sawchuk on 11-11-28.
//  Copyright (c) 2011 MML-Concordia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyLocationManager : NSObject

@property (strong,  nonatomic) CLLocationManager* manager;
@property (strong, nonatomic) NSTimer* repeatingTimer;

- (void)startManagerWithDelegate:(id)delegate;
- (void)stopManager;

@end
