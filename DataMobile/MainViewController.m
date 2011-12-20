//
//  MainViewController.m
//  DataMobile
//
//  Created by Kim Sawchuk on 11-11-25.
//  Copyright (c) 2011 MML-Concordia. All rights reserved.
//

#import "MainViewController.h"

#import "CSVExporter.h"
#import "DMAppDelegate.h"
#import "AlertViewManager.h"
#import "DatePickerController.h"
#import "FileSender.h"
#import "Config.h"

@interface MainViewController ()

- (void)updateSend;
- (void)switchStateToRecording:(BOOL)recording;
- (void)createUserIdIfNotExists;

@end

@implementation MainViewController

@synthesize startButton;
@synthesize stopButton;
@synthesize recordingLabel;
@synthesize dataLabel;
@synthesize dataButton;

@synthesize alertManager;
@synthesize appDelegate;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (IBAction)startRecording:(id)sender 
{
    alertManager = [[AlertViewManager alloc] init];
    
    // For being alerted when the user uses "No"
    alertManager.observer = self;
    
    DatePickerController* picker = [self.storyboard instantiateViewControllerWithIdentifier:@"DatePicker"];
    picker.observer = self;
    [self presentModalViewController:picker animated:YES];
}

- (IBAction)stopRecording:(id)sender 
{
    [[alertManager createConfirmStopAlert] show];
}

- (void)stopRecordingConfirmed
{
    [appDelegate stopLocationManager];
}

- (void)inputSelectedWithDay:(NSInteger)numOfDays;
{
    daysToRecord = numOfDays;
    [appDelegate startManagerWithObserver:self];
}

- (void)managerStarted
{
    [self switchStateToRecording:true];
    
    // Defining a Timer to stop recording after x seconds has passed.
    [NSTimer scheduledTimerWithTimeInterval:daysToRecord*3600*24
                                     target:self.appDelegate
                                   selector:@selector(stopLocationManager) 
                                   userInfo:nil 
                                    repeats:NO];
    
    [[alertManager createSuccessfullStartAlert] show];
}

- (void)managerStopped
{
    [self switchStateToRecording:false];
    [[alertManager createSuccessfullStopAlert] show];    
}

- (IBAction)sendData:(id)sender 
{
    
    NSArray *objects = [self.appDelegate fetchAllLocations];
    
    NSString* string_objects = [CSVExporter exportObjects:objects toLocation:@"locations.csv"];    
    NSString* user_id = [[[appDelegate fetchAllObjects:@"User"] objectAtIndex:0] valueForKey:@"id"];
    
    
    NSDictionary* postData = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                    string_objects, @"text",
                                                    user_id, @"id", nil];

    FileSender* fileSender = [[FileSender alloc] init];
    [fileSender sendPostData:postData 
                       ToURL:[[Config instance] stringValueForKey:@"insertLocationUrl"]];
        
    [self.appDelegate deleteAllLocations];
    [[alertManager createSuccessfullSentAlert] show];
    [self updateSend];
}

- (void)updateSend
{
    if([[self.appDelegate fetchAllLocations] count] != 0)
    {
        dataLabel.hidden = false;
        dataButton.hidden = false;
    }
    else
    {
        dataLabel.hidden = true;
        dataButton.hidden = true;
    }
}

- (void)switchStateToRecording:(BOOL)recording
{
    if(recording)
    {
        self.startButton.hidden = true;
        self.stopButton.hidden = false;
        recordingLabel.hidden = false;
    }
    else
    {
        self.startButton.hidden = false;
        self.stopButton.hidden = true;
        recordingLabel.hidden = true;    
    }
}


- (void)createUserIdIfNotExists
{
    if([[appDelegate fetchAllObjects:@"User"] count] == 0)
    {
        CFUUIDRef UUIDRef = CFUUIDCreate(kCFAllocatorDefault);
        CFStringRef UUIDSRef = CFUUIDCreateString(kCFAllocatorDefault, UUIDRef);
        
        [appDelegate insertUserWithId:[NSString stringWithFormat:@"%@", UUIDSRef]];
        [appDelegate saveContext];
    }
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [Config loadForFileName:@"config"];
    
    appDelegate = (DMAppDelegate*)[[UIApplication sharedApplication] delegate];
    [self createUserIdIfNotExists];
    
    NSNotificationCenter* defaultCtr = [NSNotificationCenter defaultCenter];    

    [defaultCtr addObserver:self
                   selector:@selector(updateSend)
                       name:UIApplicationWillEnterForegroundNotification
                     object:[UIApplication sharedApplication]];
    
    
}

- (void)viewDidUnload
{
    [self setStartButton:nil];
    [self setDataLabel:nil];
    [self setDataButton:nil];
    
    [self setAlertManager:nil];
    
    [self setStopButton:nil];
    [self setRecordingLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
