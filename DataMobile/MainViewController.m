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

// For determining the different states of the state button
typedef enum
{
    NO_SEND = 1,
    SEND_IN_PROGRESS = 2,
    SEND_BUTTON = 3
} SendState;

@interface MainViewController () 
{
    @private SendState sendState;
}

- (void)setSendState:(SendState)state;
- (void)updateSend;
- (void)switchStateToRecording:(BOOL)recording;
- (void)createUserIdIfNotExists;
- (void)startLocationManager;

@end

@implementation MainViewController

@synthesize startButton;
@synthesize stopButton;
@synthesize recordingLabel;
@synthesize dataLabel;
@synthesize dataButton;
@synthesize sendingLabel;

@synthesize alertManager;

@synthesize appDelegate;
@synthesize locationManager;


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
    [self.appDelegate saveContext];
    
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
    [locationManager stopManager];
}

- (void)inputSelectedWithDay:(NSInteger)numOfDays;
{
    daysToRecord = numOfDays;
    [self startLocationManager];
}

- (void)managerStarted
{
    [self switchStateToRecording:true];
    
    // Defining a Timer to stop recording after x seconds has passed.
    [NSTimer scheduledTimerWithTimeInterval:daysToRecord*3600*24
                                     target:self.locationManager
                                   selector:@selector(stopManager) 
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
    [self setSendState:SEND_IN_PROGRESS];
    
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

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation 
           fromLocation:(CLLocation *)oldLocation
{
    [self.appDelegate insertLocation:newLocation];
    if (sendState != SEND_IN_PROGRESS)
    {
        [self setSendState:SEND_BUTTON];
    }
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSString* data_response = [NSString stringWithUTF8String:[data bytes]];
    if (![FileSender errorMessageReceivedFromServer:data_response])
    {
        [self.appDelegate deleteAllLocations];
        [[alertManager createSuccessfullSentAlert] show];    
        [self setSendState:NO_SEND];
    }
    else
    {
        [[alertManager createErrorAlertWithMessage:data_response] show];
        [self setSendState:SEND_BUTTON];
    }
}

- (void)connection:(NSURLConnection *)connection 
  didFailWithError:(NSError *)error
{    
    [[alertManager createErrorAlertWithMessage:error.localizedDescription] show];
    [self setSendState:SEND_BUTTON];
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

- (void)setSendState:(SendState)state
{
    sendState = state;
    switch (state) 
    {
        case NO_SEND:
        {            
            dataLabel.hidden = true;
            dataButton.hidden = true;
            sendingLabel.hidden = true;        
        }
            break;

        case SEND_IN_PROGRESS:
        {
            dataLabel.hidden = true;
            dataButton.hidden = true;
            sendingLabel.hidden = false;                    
        }
            break;
            
        case SEND_BUTTON:
        {
            dataLabel.hidden = false;
            dataButton.hidden = false;
            sendingLabel.hidden = true;                    
        }
            break;            
            
        default:
            break;
    }
}

- (void)updateSend
{    
    [self setSendState:([[self.appDelegate fetchAllLocations] count] != 0) ? SEND_BUTTON 
                                                                            :sendState] ;
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

- (void)startLocationManager
{
    locationManager = [[MyLocationManager alloc] init];
    locationManager.observer = self;
    [locationManager startManagerWithDelegate:self];
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];    
    [Config loadForFileName:@"config"];
    
    [self updateSend];
    
    appDelegate = (DMAppDelegate*)[[UIApplication sharedApplication] delegate];
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
