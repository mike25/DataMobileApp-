//
//  MyLocationManager.h
//  DataMobile
//
//  Created by Kim Sawchuk on 11-11-28.
//  Copyright (c) 2011 MML-Concordia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyLocationManagerObserver.h"

@interface MyLocationManager : NSObject

@property (weak, nonatomic) id<MyLocationManagerObserver> observer;
@property (strong,  nonatomic) CLLocationManager* manager;

- (void)startManagerWithDelegate:(id)delegate;
- (void)stopManager;

@end
