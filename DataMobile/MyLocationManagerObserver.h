//
//  MyLocationManagerObserver.h
//  DataMobile
//
//  Created by Kim Sawchuk on 11-11-30.
//  Copyright (c) 2011 MML-Concordia. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MyLocationManagerObserver <NSObject>

@optional
- (void)managerStarted;
- (void)managerStopped;

@end
