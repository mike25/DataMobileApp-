//
//  MainViewController.h
//  DataMobile
//
//  Created by Kim Sawchuk on 11-11-25.
//  Copyright (c) 2011 MML-Concordia. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AlertObserver.h"

@class LocationManagerHandler;
@class DMAppDelegate;
@class AlertViewManager;
@class SendState;

@interface MainViewController : UIViewController <AlertObserver, NSURLConnectionDataDelegate>
{
    @private int daysToRecord;
}

@property (strong, nonatomic) IBOutlet UIButton *startButton;
@property (strong, nonatomic) IBOutlet UIButton *stopButton;
@property (strong, nonatomic) IBOutlet UILabel *recordingLabel;
@property (strong, nonatomic) IBOutlet UIButton *dataButton;
@property (strong, nonatomic) IBOutlet UILabel *sendingLabel;
@property (strong, nonatomic) IBOutlet UIButton *mapButton;

@property (strong, nonatomic) AlertViewManager* alertManager;
@property (strong, nonatomic) SendState* sendState;

@property (weak, nonatomic) DMAppDelegate* appDelegate;

- (IBAction)startRecording:(id)sender;
- (IBAction)stopRecording:(id)sender;
- (IBAction)sendData:(id)sender;
- (IBAction)viewMap:(id)sender;


- (void)managerDidStopUpdatingLocation;
- (void)managerDidUpdate;
- (void)managerDidFailWithError:(NSNotification *)notification;

- (void)inputSelected:(NSNotification*)notification;
- (void)stopRecordingConfirmed;

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;

@end
