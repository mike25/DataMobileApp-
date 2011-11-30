//
//  MainViewController.h
//  DataMobile
//
//  Created by Kim Sawchuk on 11-11-25.
//  Copyright (c) 2011 MML-Concordia. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AlertViewManager.h"
#import "MyLocationManager.h"

@class DMAppDelegate;

@interface MainViewController : UIViewController <AlertObserver, MyLocationManagerObserver>

@property (strong, nonatomic) IBOutlet UIButton *startButton;
@property (strong, nonatomic) IBOutlet UIButton *stopButton;
@property (strong, nonatomic) IBOutlet UILabel *recordingLabel;
@property (strong, nonatomic) IBOutlet UILabel *dataLabel;
@property (strong, nonatomic) IBOutlet UIButton *dataButton;

@property (strong, nonatomic) AlertViewManager* alertManager;
@property (strong, nonatomic) MyLocationManager* locationManager;

@property (weak, nonatomic) DMAppDelegate* appDelegate;

- (IBAction)startRecording:(id)sender;
- (IBAction)stopRecording:(id)sender;
- (IBAction)sendData:(id)sender;

- (void)inputCorrect:(NSInteger)numOfDays;
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
