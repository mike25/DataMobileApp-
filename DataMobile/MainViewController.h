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

@interface MainViewController : UIViewController <AlertObserver, MyLocationManagerObserver, PickerObserver, NSURLConnectionDataDelegate>
{
    @private int daysToRecord;
}

@property (strong, nonatomic) IBOutlet UIButton *startButton;
@property (strong, nonatomic) IBOutlet UIButton *stopButton;
@property (strong, nonatomic) IBOutlet UILabel *recordingLabel;
@property (strong, nonatomic) IBOutlet UILabel *dataLabel;
@property (strong, nonatomic) IBOutlet UIButton *dataButton;
@property (strong, nonatomic) IBOutlet UILabel *sendingLabel;

@property (strong, nonatomic) AlertViewManager* alertManager;
@property (weak, nonatomic) DMAppDelegate* appDelegate;

- (IBAction)startRecording:(id)sender;
- (IBAction)stopRecording:(id)sender;
- (IBAction)sendData:(id)sender;

- (void)inputSelectedWithDay:(NSInteger)numOfDays;
- (void)stopRecordingConfirmed;

- (void)managerStarted;
- (void)managerStopped;

//- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;

@end
