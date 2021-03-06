//
//  AlertViewManager.h
//  GPSRecorder
//
//  Created by Kim Sawchuk on 11-11-24.
//  Copyright (c) 2011 MML-Concordia. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AlertObserver.h"

@interface AlertViewManager : NSObject <UIAlertViewDelegate> 

// for tagging alertviews
typedef enum
{
    ERROR_OCCURED = 3,
    RECORD_STARTED = 4,
    RECORD_STOPPED = 5,
    RECORD_STOPPED_CONFIRM = 6,
    DATA_SENT = 7
} alertViewTag;

@property (weak, nonatomic) id<AlertObserver> observer;

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

- (UIAlertView*)createSuccessfullStartAlert;
- (UIAlertView*)createSuccessfullStopAlert;
- (UIAlertView*)createSuccessfullSentAlert;
- (UIAlertView*)createConfirmStopAlert;
- (UIAlertView*)createErrorAlertWithMessage:(NSString*)message;

@end
