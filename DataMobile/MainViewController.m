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
#import "CoreDataHelper.h"
#import "AlertViewManager.h"
#import "DatePickerController.h"
#import "FileSender.h"
#import "Config.h"
#import "LocationManagerHandler.h"
#import "SendState.h"
#import "MapViewController.h"

@interface MainViewController () 

- (void)switchStateToRecording:(BOOL)recording;

@end

@implementation MainViewController

@synthesize startButton;
@synthesize stopButton;
@synthesize recordingLabel;
@synthesize dataButton;
@synthesize sendingLabel;
@synthesize mapButton;

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
    
    [self.appDelegate.cdataHelper saveContext];
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

- (void)inputSelected:(NSNotification*)notification
{
    NSNumber* numOfDays = (NSNumber*)[[notification userInfo] objectForKey:@"numOfDays"];
    
    [appDelegate startUpdatingLocationsForDays:[numOfDays integerValue]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(managerDidStopUpdatingLocation)
                                                 name:@"ManagerDidStopUpdatingLocation" 
                                               object:appDelegate.managerHandler];

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
    
    NSArray *objects = [self.appDelegate.cdataHelper fetchAllLocations];
    
    NSString* string_objects = [CSVExporter exportObjects:objects toLocation:@"locations.csv"];    
    NSString* user_id = [[[appDelegate.cdataHelper fetchAllUsers] objectAtIndex:0] valueForKey:@"id"];    
    
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
        [appDelegate.cdataHelper deleteAllLocations];
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

    // For being alerted when the user uses "No"    
    alertManager = [[AlertViewManager alloc] init];    
    alertManager.observer = self;
        
    appDelegate = (DMAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(ManagerDidFailWithError:)
                                                 name:@"ManagerDidFailWithError" 
                                               object:appDelegate.managerHandler];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(managerDidUpdate)
                                                 name:@"ManagerDidUpdateLocation" 
                                               object:appDelegate.managerHandler];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(inputSelected:)
                                                 name:@"NumberOfDaysInputSelected"
                                               object:nil];
    
    self.sendState = [SendState determineInitialStateForController:self];
    [sendState executeForController:self];
}

- (void)viewDidUnload
{
    [self setStartButton:nil];
    [self setDataButton:nil];
    
    [self setAlertManager:nil];
    [self setStopButton:nil];
    [self setRecordingLabel:nil];
    [self setSendingLabel:nil];
    
    [self setMapButton:nil];
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
