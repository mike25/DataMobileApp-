//
//  PickerObserver.h
//  DataMobile
//
//  Created by Kim Sawchuk on 11-11-30.
//  Copyright (c) 2011 MML-Concordia. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PickerObserver <NSObject>

-(void)inputSelectedWithDay:(NSInteger)numOfDays;

@end