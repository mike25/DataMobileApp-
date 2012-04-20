//
//  KIFTestStep+MapStepsAddition.m
//  DataMobile
//
//  Created by Zachary Patterson on 4/19/12.
//  Copyright (c) 2012 MML-Concordia. All rights reserved.
//

#import "KIFTestStep+MapStepsAddition.h"
#import "KIFTestStep+DatePickerAddition.h"

@implementation KIFTestStep (MapStepsAddition)

+ (NSArray *)stepsToPickDate:(NSDate*)date
{
    NSMutableArray *steps = [NSMutableArray array];
    
    NSDateFormatter* dayFormatter = [[NSDateFormatter alloc] init];
    [dayFormatter setDateFormat:@"d MMM"];
    
    NSDateFormatter* hourFormatter = [[NSDateFormatter alloc] init];
    [hourFormatter setDateFormat:@"hh"];
    
    NSDateFormatter* minFormatter = [[NSDateFormatter alloc] init];
    [minFormatter setDateFormat:@"mm"];
    
    [steps addObject:[KIFTestStep stepToSelectPickerViewRowWithTitle:[dayFormatter stringFromDate:date] 
                                                        forComponent:0]];
    [steps addObject:[KIFTestStep stepToSelectPickerViewRowWithTitle:[hourFormatter stringFromDate:date] 
                                                        forComponent:1]];
    [steps addObject:[KIFTestStep stepToSelectPickerViewRowWithTitle:[minFormatter stringFromDate:date] 
                                                        forComponent:2]];    
    
    return steps;
}

+ (NSArray *)stepsToSelectTimePeriodWithStartDate:(NSDate*)startDate
                                       AndEndDate:(NSDate*)endDate
{
    NSMutableArray *steps = [NSMutableArray array];
    
    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Start"]];
    [steps addObjectsFromArray:[KIFTestStep stepsToPickDate:startDate]];    
    
    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"End"]];
    [steps addObjectsFromArray:[KIFTestStep stepsToPickDate:endDate]];

    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Go" 
                                                              traits:UIAccessibilityTraitButton]];
    
    return steps;
}

@end
