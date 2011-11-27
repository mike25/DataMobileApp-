//
//  MainViewController.h
//  DataMobile
//
//  Created by Kim Sawchuk on 11-11-25.
//  Copyright (c) 2011 MML-Concordia. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AlertViewManager.h"

@class DMAppDelegate;

@interface MainViewController : UIViewController <AlertObserver>

@property (strong, nonatomic) IBOutlet UIButton *startButton;
@property (strong, nonatomic) IBOutlet UIButton *stopButton;
@property (strong, nonatomic) IBOutlet UILabel *recordingLabel;
@property (strong, nonatomic) IBOutlet UILabel *dataLabel;
@property (strong, nonatomic) IBOutlet UIButton *dataButton;

@property (strong, nonatomic) AlertViewManager* alertManager;

- (IBAction)startRecording:(id)sender;
- (IBAction)stopRecording:(id)sender;
- (IBAction)sendData:(id)sender;

- (void)inputCorrect:(int)numOfDays;
- (void)stopRecordingConfirmed;

/**
 * helper methods
 */
- (void)updateSend;
- (DMAppDelegate*)appDelegate;
- (void)switchStateToRecording:(BOOL)recording;

@end
