//
//  AlertObserver.h
//  DataMobile
//
//  Created by Kim Sawchuk on 11-11-30.
//  Copyright (c) 2011 MML-Concordia. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AlertObserver 

/**
 * Executes when the user has selected a Number of Days
 */
- (void)stopRecordingConfirmed;

@end
