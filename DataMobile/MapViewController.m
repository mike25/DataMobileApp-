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

@implementation MapViewController

@synthesize cdHelper;
@synthesize map;
@synthesize locations;

- (void)drawAllLocations
{
    CLLocationCoordinate2D* coordinates = malloc(sizeof(CLLocationCoordinate2D)*[locations count]);
    for (int i = 0; i < [locations count]; i++)
    {
        coordinates[i] = [MapViewController LocationToCoordinate:[locations objectAtIndex:i]];
    }
        
    MKPolyline *polyLine = [MKPolyline polylineWithCoordinates:coordinates 
                                                         count:[locations count]];
    [map addOverlay:polyLine];
    free(coordinates);
}

- (CLLocationCoordinate2D)getLastCoordinate
{
    // The locations are sorted in timestamp ascending order.
    NSManagedObject *lastLocation = [self.locations objectAtIndex:0];

    return [MapViewController LocationToCoordinate:lastLocation];
}

+ (CLLocationCoordinate2D)LocationToCoordinate:(NSManagedObject*)location 
{
    return CLLocationCoordinate2DMake([[location valueForKey:@"latitude"] doubleValue], 
                                      [[location valueForKey:@"longitude"] doubleValue]);    
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
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance([self getLastCoordinate], 0.5*1609, 0.5*1609);
    MKCoordinateRegion adjustedRegion = [self.map regionThatFits:viewRegion];                
    [self.map setRegion:adjustedRegion animated:YES];
        
    [self drawAllLocations];
}

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
    
    UIApplication* app = [UIApplication sharedApplication];  
    
    DMAppDelegate* delegate = (DMAppDelegate*)[app delegate];    
    self.cdHelper = delegate.cdataHelper;    
    NSDate* today = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
    NSDate* yersterday = [[NSDate alloc] initWithTimeInterval:-1*3600*24
                                                    sinceDate:today];
    self.locations = [cdHelper fetchLocationsFromDate:yersterday
                                               ToDate:today];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(drawAllLocations) 
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:app];
}


- (void)viewDidUnload
{
    [self setMap:nil];
    [self setLocations:nil];
    
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
