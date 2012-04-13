//
//  DMAppDelegate.h
//  DataMobile
//
//  Created by Kim Sawchuk on 11-11-25.
//  Copyright (c) 2011 MML-Concordia. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LocationManagerHandler;
@class CoreDataHelper;

@interface DMAppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) CoreDataHelper* cdataHelper;
@property (strong, nonatomic) LocationManagerHandler* managerHandler;

- (void)startUpdatingLocationsForDays:(NSInteger)numOfDays;
- (void)stopUpdatingLocations;

@end
