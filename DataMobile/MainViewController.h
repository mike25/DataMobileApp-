//
//  MainViewController.h
//  DataMobile
//
//  Created by Kim Sawchuk on 11-11-25.
//  Copyright (c) 2011 MML-Concordia. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AlertObserver.h"
#import "MyLocationManager.h"
#import "MyLocationManagerObserver.h"
#import "PickerObserver.h"

@class DMAppDelegate;
@class AlertViewManager;

@interface MainViewController : UIViewController <AlertObserver, MyLocationManagerObserver, PickerObserver>
{
    @private int daysToRecord;
}

@property (strong, nonatomic) IBOutlet UIButton *startButton;
@property (strong, nonatomic) IBOutlet UIButton *stopButton;
@property (strong, nonatomic) IBOutlet UILabel *recordingLabel;
@property (strong, nonatomic) IBOutlet UILabel *dataLabel;
@property (strong, nonatomic) IBOutlet UIButton *dataButton;

@property (strong, nonatomic) AlertViewManager* alertManager;
@property (weak, nonatomic) DMAppDelegate* appDelegate;

- (IBAction)startRecording:(id)sender;
- (IBAction)stopRecording:(id)sender;
- (IBAction)sendData:(id)sender;

- (void)inputSelectedWithDay:(NSInteger)numOfDays;
- (void)stopRecordingConfirmed;

- (void)managerStarted;
- (void)managerStopped;

/**
 * helper methods
 */
- (void)updateSend;
- (DMAppDelegate*)appDelegate;
- (void)switchStateToRecording:(BOOL)recording;

@end
