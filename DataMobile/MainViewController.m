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
#import "MyLocationManager.h"
#import "SendState.h"

@interface MainViewController () 

- (void)switchStateToRecording:(BOOL)recording;
- (void)createUserIdIfNotExists;

@end

@implementation MainViewController

@synthesize startButton;
@synthesize stopButton;
@synthesize recordingLabel;
@synthesize dataLabel;
@synthesize dataButton;
@synthesize sendingLabel;

@synthesize alertManager;
@synthesize sendState;

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
    
    [self.appDelegate saveContext];
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (IBAction)stopRecording:(id)sender 
{
    [[alertManager createConfirmStopAlert] show];
}

- (void)stopRecordingConfirmed
{
    [appDelegate stopUpdatingLocations];
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

- (void)inputSelectedWithDay:(NSInteger)numOfDays;
{
    [appDelegate startUpdatingLocationsForDays:numOfDays];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(managerDidStopUpdatingLocation)
                                                 name:@"ManagerDidStopUpdatingLocation" 
                                               object:appDelegate.locationManager];

    [self switchStateToRecording:true];
    [[alertManager createSuccessfullStartAlert] show];    
    [self.sendState locationManagerDidUpdateForController:self];
}

- (void)managerDidStopUpdatingLocation
{
    [self switchStateToRecording:false];
    [[alertManager createSuccessfullStopAlert] show];
}

- (void)managerDidFailWithError:(NSNotification *)notification
{
    NSError* error = (NSError*)[notification userInfo];
    [[alertManager createErrorAlertWithMessage:error.localizedDescription] show];
}

- (void)managerDidUpdate
{
    [sendState locationManagerDidUpdateForController:self];
}

- (IBAction)sendData:(id)sender 
{    
    [sendState didSendDataForController:self];
    
    NSArray *objects = [self.appDelegate fetchAllLocations];
    
    NSString* string_objects = [CSVExporter exportObjects:objects toLocation:@"locations.csv"];    
    NSString* user_id = [[[appDelegate fetchAllObjects:@"User"] objectAtIndex:0] valueForKey:@"id"];    
    
    NSDictionary* postData = [[NSDictionary alloc] initWithObjectsAndKeys:
                              string_objects, @"text",
                              user_id, @"id", nil];
    
    FileSender* fileSender = [[FileSender alloc] init];
    [fileSender sendRequestWithPostData:postData
                                  ToURL:[[Config instance] stringValueForKey:@"insertLocationUrl"]
                           WithDelegate:self];
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSString* data_response = [NSString stringWithUTF8String:[data bytes]];
    if (![FileSender errorMessageReceivedFromServer:data_response])
    {
        [appDelegate deleteAllLocations];
        [[alertManager createSuccessfullSentAlert] show];
        [sendState connectionDidReceiveDataWithoutErrorForController:self];
    }
    else
    {
        [[alertManager createErrorAlertWithMessage:data_response] show];
        [sendState connectionDidReceiveDataWithErrorForController:self];
    }
}

- (void)connection:(NSURLConnection *)connection 
  didFailWithError:(NSError *)error
{    
    [[alertManager createErrorAlertWithMessage:error.localizedDescription] show];
    [sendState connectionDidFailForController:self];
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

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];    
    [Config loadForFileName:@"config"];
    
    self.sendState = [SendState determineInitialStateForController:self];
    
    appDelegate = (DMAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(ManagerDidFailWithError)
                                                 name:@"ManagerDidFailWithError" 
                                               object:appDelegate];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(managerDidUpdate)
                                                 name:@"ManagerDidUpdateLocation" 
                                               object:appDelegate];
    
    [self createUserIdIfNotExists];
}

- (void)viewDidUnload
{
    [self setStartButton:nil];
    [self setDataLabel:nil];
    [self setDataButton:nil];
    
    [self setAlertManager:nil];
    
    [self setStopButton:nil];
    [self setRecordingLabel:nil];
    [self setSendingLabel:nil];
    
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
