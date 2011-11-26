//
//  AlertViewManager.m
//  GPSRecorder
//
//  Created by Kim Sawchuk on 11-11-24.
//  Copyright (c) 2011 MML-Concordia. All rights reserved.
//

#import "AlertViewManager.h"

@implementation AlertViewManager

@synthesize observer;

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    UIAlertView* message;
    
    switch ([alertView tag]) 
    { 
        case RECORD:
        {
            if([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"OK"])
            {
                // Checking if input is a digit
                NSString* input = [[alertView textFieldAtIndex:0] text];
                NSError *error = NULL;            
                NSRegularExpression* regexp = [NSRegularExpression regularExpressionWithPattern:@"\^[0-9]+$"
                                                                                        options:0 
                                                                                          error:&error];
                NSTextCheckingResult* match = [regexp firstMatchInString:input 
                                                                 options:0 
                                                                   range:NSMakeRange(0, [input length])];
                if (match)
                {
                    int inputNum = [input intValue];
                    if(inputNum <= MAXRECORDINGPERIOD)
                    {
                        [observer inputCorrect:inputNum];
                        
                        [[self createOkAlert:@"Recording started" 
                                 withMessage:@"You can put the recorder in background now, please dont reboot your iphone, as you would need to start this application again."
                                      setTag:RECORD_STARTED] show];
                    }
                    else
                    {
                        NSString* msg = [[NSString alloc] initWithFormat:@"Please input a number < %d", MAXRECORDINGPERIOD];                    
                        [[self createOkAlert:@"Too long period" 
                                 withMessage:msg
                                      setTag:TOO_lONG] show];
                    }
                }
                else 
                {
                    NSString* msg = [[NSString alloc] initWithFormat:@"Please input a number < %d", MAXRECORDINGPERIOD];                    
                    [[self createOkAlert:@"Not a Day" 
                             withMessage:msg
                                  setTag:NOT_A_DAY] show];
                }
            }
        }   
            break;
            
        case NOT_A_DAY:{}   
            
        case TOO_lONG:
        {
            [[self createConfirmRecordView] show];
        }   break;
            
        default:
            break;
    }
    [message show];
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

- (UIAlertView*)createConfirmRecordView
{
    NSString* msgtxt = [[NSString alloc] initWithFormat:@"(max = %d)", MAXRECORDINGPERIOD];
    
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Enter number of days"
                                                        message:msgtxt
                                                       delegate:self
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles:@"Cancel", nil];
    [alertView setTag:RECORD];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    return alertView;  
}

@end
