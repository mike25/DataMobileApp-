//
//  KIFTestStep+DataMBAdditions.m
//  DataMobile
//
//  Created by Zachary Patterson on 3/24/12.
//  Copyright (c) 2012 MML-Concordia. All rights reserved.
//

#import "KIFTestStep+DataMBAdditions.h"

@implementation KIFTestStep (DataMBAdditions)

#pragma mark - Factory Steps

+ (id)stepToReset
{
    return [KIFTestStep stepWithDescription:@"Reset the application state." executionBlock:^(KIFTestStep *step, NSError **error) {
        BOOL successfulReset = YES;
        
        // Do the actual reset for your app. Set successfulReset = NO if it fails.
        
        KIFTestCondition(successfulReset, error, @"Failed to reset the application.");
        
        return KIFTestStepResultSuccess;
    }];
}

#pragma mark - Step Collections


+ (NSArray *)stepsToWaitForLocationNotifications:(NSInteger)numberOfNotifications
{
    NSMutableArray *steps = [NSMutableArray array];

    for (int i = 0; i < numberOfNotifications ; i++) 
    {
        [steps addObject:[KIFTestStep stepToWaitForTimeInterval:POLLINTERVALSECONDS-1
                                                   description:@"wait for the next location recording to come"]];
        [steps addObject:[KIFTestStep stepToWaitForNotificationName:@"ManagerDidUpdateLocation" 
                                                                                   object:nil]];
    }
    
    return steps;
}

@end
