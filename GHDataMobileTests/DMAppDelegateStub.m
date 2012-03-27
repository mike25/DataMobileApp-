//
//  DMAppDelegateStub.m
//  DataMobile
//
//  Created by Zachary Patterson on 3/26/12.
//  Copyright (c) 2012 MML-Concordia. All rights reserved.
//

#import "DMAppDelegateStub.h"

#import "CoreDataHelper.h"
#import "LocationManagerHandler.h"

@interface DMAppDelegateStub ()
@end

@implementation DMAppDelegateStub

@synthesize mockCDataHelper;
@synthesize mockManagerHandler;

- (id)cdataHelper
{
    return [self mockCDataHelper];
}

- (id)managerHandler
{
    return [self mockManagerHandler];    
}

- (void)startUpdatingLocationsForDays:(NSInteger)numOfDays{}
- (void)stopUpdatingLocations{}

@end
