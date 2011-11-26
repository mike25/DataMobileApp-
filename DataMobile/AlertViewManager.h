//
//  AlertViewManager.h
//  GPSRecorder
//
//  Created by Kim Sawchuk on 11-11-24.
//  Copyright (c) 2011 MML-Concordia. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AlertObserver

/**
 * Executes when the user has entered a correct value (number of days < maxnumberofdays)
 */
- (void)inputCorrect:(int)numOfDays;

@end

@interface AlertViewManager : NSObject <UIAlertViewDelegate> 

// for tagging alertviews
typedef enum
{
    RECORD = 1,
    NOT_A_DAY = 2,
    TOO_lONG = 3,
    RECORD_STARTED = 4
} alertViewTag;

@property (weak, nonatomic) id<AlertObserver> observer;

- (UIAlertView*)createConfirmRecordView;

/**
 * Helper Methods
 */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
- (UIAlertView*)createOkAlert:(NSString*)title withMessage:(NSString*)message setTag:(alertViewTag)tag;

@end
