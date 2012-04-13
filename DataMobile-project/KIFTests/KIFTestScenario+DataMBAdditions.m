//
//  KIFTestScenario.m
//  DataMobile
//
//  Created by Zachary Patterson on 3/24/12.
//  Copyright (c) 2012 MML-Concordia. All rights reserved.
//

#import "KIFTestScenario+DataMBAdditions.h"
#import "KIFTestStep+DataMBAdditions.h"

@implementation KIFTestScenario (DataMBAdditions)

+ (id)scenarioToLogIn
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test that a user can successfully log in."];
    [scenario addStep:[KIFTestStep stepToReset]];
        
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
    [scenario addStep:[KIFTestStep stepToReset]];

    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"map" traits:UIAccessibilityTraitButton]];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"map" traits:UIAccessibilityScreenChangedNotification]];
    
    return scenario;
}

@end
