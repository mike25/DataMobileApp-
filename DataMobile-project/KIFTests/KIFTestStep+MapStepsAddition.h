//
//  KIFTestStep+MapStepsAddition.h
//  DataMobile
//
//  Created by Zachary Patterson on 4/19/12.
//  Copyright (c) 2012 MML-Concordia. All rights reserved.
//

#import "KIFTestStep.h"

@interface KIFTestStep (MapStepsAddition)

+ (id)stepToWaitForMapToGenerate;

+ (NSArray *)stepsToPickDate:(NSDate*)date;
+ (NSArray *)stepsToSelectTimePeriodWithStartDate:(NSDate*)startDate
                                       AndEndDate:(NSDate*)endDate;

@end
