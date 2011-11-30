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

@implementation MainViewController

@synthesize startButton;
@synthesize stopButton;
@synthesize recordingLabel;
@synthesize dataLabel;
@synthesize dataButton;

@synthesize alertManager;
@synthesize locationManager;
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
    alertManager.observer = self;
    
    DatePickerController* picker = [self.storyboard instantiateViewControllerWithIdentifier:@"DatePicker"];
    picker.observer = [self alertManager];
    [self presentModalViewController:picker animated:YES];
}

- (IBAction)stopRecording:(id)sender 
{
    [[alertManager createConfirmStopAlert] show];
}

- (void)inputCorrect:(NSInteger)numOfDays;
{
    locationManager = [[MyLocationManager alloc] init];
    [locationManager.observers addObject:self];
    [locationManager.observers addObject:self.appDelegate];
    [locationManager startManager];
    
    // Defining a Timer to stop recording after x seconds has passed.
    [NSTimer scheduledTimerWithTimeInterval:numOfDays*3600*24
                                     target:locationManager
                                   selector:@selector(stopManager) 
                                   userInfo:nil 
                                    repeats:NO];
}

- (void)stopRecordingConfirmed
{
    [self.locationManager stopManager];
    locationManager = nil;
}

- (void)managerStarted
{
    [self switchStateToRecording:true];
}

- (void)managerStopped
{
    [self switchStateToRecording:false];
}

- (IBAction)sendData:(id)sender 
{
    
    NSArray *objects = [self.appDelegate fetchAllLocations];
    
    if (objects == nil)
    {
        NSLog(@"There was an error!");
    }
    
    [CSVExporter exportObjects:objects toLocation:@"locations.csv"];
    [self.appDelegate deleteAllLocations];
    [[alertManager createSuccessfullSentAlert] show];
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

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.

- (void)viewDidLoad
{
    [super viewDidLoad];

    appDelegate = (DMAppDelegate*)[[UIApplication sharedApplication] delegate];         
    NSNotificationCenter* defaultCtr = [NSNotificationCenter defaultCenter];    
    [defaultCtr addObserver:self
                   selector:@selector(updateSend)
                       name:NSManagedObjectContextDidSaveNotification
                     object:[self.appDelegate managedObjectContext]];
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
    [self setLocationManager:nil];
    
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
