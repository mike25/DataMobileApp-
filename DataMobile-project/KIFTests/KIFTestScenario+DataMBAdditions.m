//
//  KIFTestScenario.m
//  DataMobile
//
//  Created by Zachary Patterson on 3/24/12.
//  Copyright (c) 2012 MML-Concordia. All rights reserved.
//

#import "KIFTestScenario+DataMBAdditions.h"
#import "KIFTestStep+DataMBAdditions.h"
#import "KIFTestStep+MapStepsAddition.h"

@implementation KIFTestScenario (DataMBAdditions)

+ (id)scenarioToLogIn
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test that a user can successfully log in."];
        
    return scenario;
}

+ (id)scenarioToStartRecording
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test that a user can start Recording."];
    [scenario addStep:[KIFTestStep stepToReset]];
    
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"start" traits:UIAccessibilityTraitButton]];
    [scenario addStep:[KIFTestStep stepToSelectPickerViewRowWithTitle:@"2"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"select" traits:UIAccessibilityTraitButton]];
    
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Recording started"]];    
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"OK" traits:UIAccessibilityTraitButton]];
    
    [scenario addStepsFromArray:[KIFTestStep stepsToWaitForLocationNotifications:5]];
    
    return scenario;
}

+ (id)scenarioToGoToMap
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test that a user can read a map routes."];    

    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"map" traits:UIAccessibilityTraitButton]];
    
    /* Selecting Time Interval */
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"d MMM yyyy, hh:mm"];
    
    NSDate *startDate = [dateFormatter dateFromString:@"17 Apr 2012, 07:00"];
    NSDate *endDate = [dateFormatter dateFromString:@"18 Apr 2012, 07:00"];    
    
    [scenario addStepsFromArray:[KIFTestStep stepsToSelectTimePeriodWithStartDate:startDate 
                                                                       AndEndDate:endDate]];
    
    /* Tapping on back button */
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Welcome To DataMobile"]];
    
    return scenario;
}

@end
