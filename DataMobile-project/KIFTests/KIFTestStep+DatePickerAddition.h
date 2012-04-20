//
//  KIFTestStep+DatePickerAddition.h
//  DataMobile
//
//  Created by Zachary Patterson on 4/19/12.
//  Copyright (c) 2012 MML-Concordia. All rights reserved.
//

#import "KIFTestStep.h"

@interface KIFTestStep (DatePickerAddition)

/**
 * taken from https://github.com/square/KIF/pull/80/files
 */
+ (id)stepToSelectPickerViewRowWithTitle:(NSString *)title 
                            forComponent:(NSUInteger)componentIndex;

@end
