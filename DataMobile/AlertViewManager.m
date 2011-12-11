//
//  AlertViewManager.m
//  GPSRecorder
//
//  Created by Kim Sawchuk on 11-11-24.
//  Copyright (c) 2011 MML-Concordia. All rights reserved.
//

#import "AlertViewManager.h"

@interface AlertViewManager ()

- (UIAlertView*)createOkAlert:(NSString*)title withMessage:(NSString*)message setTag:(alertViewTag)tag;
- (UIAlertView*)createOkCancelAlert:(NSString*)title withMessage:(NSString*)message setTag:(alertViewTag)tag;

@end

@implementation AlertViewManager

@synthesize observer;

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch ([alertView tag]) 
    { 
        case RECORD_STOPPED_CONFIRM:
        {
            if([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"OK"])
            {
                [self.observer stopRecordingConfirmed];
            }
        }
            
        default:
            break;
    }
}

- (UIAlertView*)createSuccessfullStartAlert
{
    return [self createOkAlert:@"Recording started" 
                   withMessage:@"You can put the recorder in background now, please dont reboot your iphone, as you would need to start this application again."
                        setTag:RECORD_STARTED];
}

- (UIAlertView*)createSuccessfullStopAlert
{
    return [self createOkAlert:@"Recording Stopped" 
                   withMessage:@"If you data has recorded data, we would grateful if you send them to us." 
                        setTag:RECORD_STOPPED];
}

- (UIAlertView*)createSuccessfullSentAlert
{
    return [self createOkAlert:@"Data successfully Sent" 
                   withMessage:@"Thank you for participating"
                        setTag:DATA_SENT];
}

- (UIAlertView*)createConfirmStopAlert
{
    return [self createOkCancelAlert:@"Are you sure ?" 
                         withMessage:@"The application will stop recording your movements" 
                              setTag:RECORD_STOPPED_CONFIRM];
}

- (UIAlertView*)createOkCancelAlert:(NSString*)title 
                        withMessage:(NSString*)message
                             setTag:(alertViewTag)tag
{
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles:@"Cancel", nil];
    
    [alertView setTag:tag];
    return alertView;
}

- (UIAlertView*)createOkAlert:(NSString*)title withMessage:(NSString*)message setTag:(alertViewTag)tag
{
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles:nil];
    [alertView setTag:tag];
    return alertView;
}

@end
