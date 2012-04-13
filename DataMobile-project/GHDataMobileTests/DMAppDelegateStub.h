//
//  DMAppDelegateStub.h
//  DataMobile
//
//  Created by Zachary Patterson on 3/26/12.
//  Copyright (c) 2012 MML-Concordia. All rights reserved.
//

@interface DMAppDelegateStub : GHUnitIOSAppDelegate

@property (strong,nonatomic) id mockCDataHelper;
@property (strong,nonatomic) id mockManagerHandler;

- (id)cdataHelper;
- (id)managerHandler;

- (void)startUpdatingLocationsForDays:(NSInteger)numOfDays;
- (void)stopUpdatingLocations;

@end
