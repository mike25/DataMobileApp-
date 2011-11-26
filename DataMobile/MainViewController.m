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

@implementation MainViewController

@synthesize startButton;
@synthesize dataLabel;
@synthesize dataButton;
@synthesize alertManager;



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
    [[alertManager createConfirmRecordView] show];
}

- (void)inputCorrect:(int)numOfDays;
{
    DMAppDelegate* appdelegate = [self appDelegate];
    [appdelegate startManager];
    
    // Defining a Timer to stop recording after x seconds has passed.
    [NSTimer scheduledTimerWithTimeInterval:numOfDays*3600*24
                                     target:appdelegate
                                   selector:@selector(stopManager) 
                                   userInfo:nil 
                                    repeats:NO];
}

- (IBAction)sendData:(id)sender 
{
    
    NSArray *objects = [[self appDelegate] fetchAllLocations];
    
    if (objects == nil)
    {
        NSLog(@"There was an error!");
    }
    
    [CSVExporter exportObjects:objects toLocation:@"locations.csv"];
    
    [[self appDelegate] deleteAllLocations];
}

- (void)updateSend
{
    if([[[self appDelegate] fetchAllLocations] count] != 0)
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

- (DMAppDelegate*)appDelegate
{
    return (DMAppDelegate*)[[UIApplication sharedApplication] delegate];
}


#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIApplication* app = [UIApplication sharedApplication];
    NSNotificationCenter* defaultCtr = [NSNotificationCenter defaultCenter];
    
    [defaultCtr addObserver:self
                   selector:@selector(updateSend)
                       name:NSManagedObjectContextDidSaveNotification
                     object:app];
    
    [defaultCtr addObserver:self
                   selector:@selector(updateSend)
                       name:UIApplicationWillEnterForegroundNotification
                     object:app];
}

- (void)viewDidUnload
{
    [self setStartButton:nil];
    [self setDataLabel:nil];
    [self setDataButton:nil];
    
    [self setAlertManager:nil];
    
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
