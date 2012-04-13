//
//  KIFTestStep+DataMBAdditions.h
//  DataMobile
//
//  Created by Zachary Patterson on 3/24/12.
//  Copyright (c) 2012 MML-Concordia. All rights reserved.
//

#import "KIFTestStep.h"

@interface KIFTestStep (DataMBAdditions)

// Factory Steps
+ (id)stepToReset;

/**
 *  Steps 
 */
+ (NSArray *)stepsToWaitForLocationNotifications:(NSInteger)numberOfNotifications;

@end
