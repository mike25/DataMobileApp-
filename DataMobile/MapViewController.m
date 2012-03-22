//
//  MapViewController.m
//  DataMobile
//
//  Created by Zachary Patterson on 2/29/12.
//  Copyright (c) 2012 MML-Concordia. All rights reserved.
//

#import "MapViewController.h"
#import "DMAppDelegate.h"
#import "CoreDataHelper.h"
#import "MyMapAnnotation.h"

@implementation MapViewController

@synthesize cdHelper;
@synthesize map;
@synthesize annotations;
@synthesize datePicker;
@synthesize segmentControl;
@synthesize goButton;
@synthesize startDate;
@synthesize endDate;

- (void)drawLocations:(NSArray*)newLocations
{
    CLLocationCoordinate2D* coordinates = malloc(sizeof(CLLocationCoordinate2D)*[newLocations count]);
    for (int i = 0; i < [newLocations count]; i++)
    {
        MyMapAnnotation* note = (MyMapAnnotation*)[newLocations objectAtIndex:i];
        coordinates[i] = [note coordinate];
    }
    MKPolyline *polyLine = [MKPolyline polylineWithCoordinates:coordinates 
                                                         count:[newLocations count]];        
    [map addOverlay:polyLine];
    free(coordinates);
    
    //Add start and end annotations
    MyMapAnnotation* depart_notation = (MyMapAnnotation*)[newLocations objectAtIndex:[newLocations count]-1];
    MyMapAnnotation* last_notation = (MyMapAnnotation*)[newLocations objectAtIndex:0];    
    [self.map addAnnotation:depart_notation];
    [self.map addAnnotation:last_notation];
    
    self.annotations = newLocations;
}

- (void)drawLocationsForStartDate:(NSDate*)start WithEndDate:(NSDate*)end
{
    NSArray* objects = [cdHelper fetchLocationsFromDate:start
                                                 ToDate:end];    
    [self drawLocations:[MyMapAnnotation initFromArray:objects]];    
}

- (CLLocationCoordinate2D)getLastCoordinate:(NSArray*)locations
{
    // The locations are sorted in timestamp ascending order.
    MyMapAnnotation *lastLocation = (MyMapAnnotation*)[locations objectAtIndex:0];
    return [lastLocation coordinate];
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
}


# pragma mark - MKMapViewDelegate

-(MKOverlayView*)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay
{
	if ([overlay isKindOfClass:[MKPolyline class]]) {
		
		MKPolylineView *polylineView = [[MKPolylineView alloc] initWithPolyline:overlay];
		polylineView.strokeColor = [UIColor blueColor];
		polylineView.lineWidth = 1.5;
		return polylineView;
	}
	
	return [[MKOverlayView alloc] initWithOverlay:overlay];
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
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance([self getLastCoordinate:self.annotations], 0.5*1609, 0.5*1609);
    MKCoordinateRegion adjustedRegion = [self.map regionThatFits:viewRegion];                
    [self.map setRegion:adjustedRegion animated:YES];
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
    
    self.map.delegate = self;
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
                                             selector:@selector(drawAllLocations) 
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:app];
}

- (void)viewDidUnload
{
    [self setMap:nil];
    [self setAnnotations:nil];
    
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
