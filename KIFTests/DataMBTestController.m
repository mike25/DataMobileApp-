//
//  DataMBTestController.m
//  DataMobile
//
//  Created by Zachary Patterson on 3/24/12.
//  Copyright (c) 2012 MML-Concordia. All rights reserved.
//

#import "DataMBTestController.h"
#import "KIFTestScenario+DataMBAdditions.h"

@implementation DataMBTestController

- (void)initializeScenarios
{
    [self addScenario:[KIFTestScenario scenarioToLogIn]];
    [self addScenario:[KIFTestScenario scenarioToGoToMap]];     
    [self addScenario:[KIFTestScenario scenarioToStartRecording]];
    // Add additional scenarios you want to test here
}

@end
