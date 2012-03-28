//
//  MapViewController.m
//  DataMobile
//
//  Created by Zachary Patterson on 2/29/12.
//  Copyright (c) 2012 MML-Concordia. All rights reserved.
//

#import "DMMapView.h"
#import "MapViewController.h"
#import "DMAppDelegate.h"
#import "CoreDataHelper.h"
#import "MyMapAnnotation.h"

@interface MapViewController ()

- (void)UIApplicationWillEnterForeground;

/**
 * Draws locations that have been recorded from startDate to EndDate
 */
- (void)drawLocationsForStartDate:(NSDate*)start WithEndDate:(NSDate*)end;


@end

@implementation MapViewController

@synthesize cdHelper;
@synthesize map;
@synthesize datePicker;
@synthesize segmentControl;
@synthesize goButton;
@synthesize startDate;
@synthesize endDate;

- (void)drawLocationsForStartDate:(NSDate*)start WithEndDate:(NSDate*)end
{
    NSArray* objects = [cdHelper fetchLocationsFromDate:start
                                                 ToDate:end];    
    [self.map drawLocations:[MyMapAnnotation initFromArray:objects]];    
}

- (IBAction)startEndValueChanged:(id)sender 
{
    self.datePicker.hidden = NO;
    
    switch (self.segmentControl.selectedSegmentIndex) 
    {
        // case Start     
        case 0:
        {
            [self.datePicker setDate:self.startDate animated:YES];
        }            
            break;

        // case End     
        case 1:
        {
            [self.datePicker setDate:self.endDate animated:YES];
        }            
            break;            
            
        default:
            break;
    }
}

- (IBAction)dateValueChanged:(id)sender 
{
    switch (self.segmentControl.selectedSegmentIndex) 
    {
            // case Start     
        case 0:
        {
            self.startDate = [self.datePicker date];
        }            
            break;
            
            // case End     
        case 1:
        {
            self.endDate = [self.datePicker date];
        }            
            break;            
            
        default:
            break;
    }
}

- (IBAction)goButtonTouched:(id)sender 
{
    self.datePicker.hidden = true;
    
    [self drawLocationsForStartDate:startDate 
                        WithEndDate:endDate];
}

- (void)UIApplicationWillEnterForeground
{
    [self.map drawLocations:self.map.myLocations];
}

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

#pragma mark - View lifecycle

-(void)viewWillAppear:(BOOL)animated
{
    [self drawLocationsForStartDate:self.startDate 
                        WithEndDate:self.endDate];

    [self.map centerToRegion:MKCoordinateRegionMakeWithDistance([self.map getLastCoordinate],
                                                                0.5*1609, 
                                                                0.5*1609)];
}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.map.delegate = self.map;
    self.map.showsUserLocation = YES;
    
    UIApplication* app = [UIApplication sharedApplication];  
    
    DMAppDelegate* delegate = (DMAppDelegate*)[app delegate];    
    self.cdHelper = delegate.cdataHelper;
    
    NSDate* today = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
    NSDate* yersterday = [[NSDate alloc] initWithTimeInterval:-1*3600*24
                                                    sinceDate:today];
    
    self.startDate = yersterday;
    self.endDate = today;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(UIApplicationWillEnterForeground) 
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:app];
}

- (void)viewDidUnload
{
    [self setMap:nil];
    
    [self setStartDate:nil];
    [self setEndDate:nil];
    
    [self setDatePicker:nil];
    [self setSegmentControl:nil];
    [self setGoButton:nil];
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
