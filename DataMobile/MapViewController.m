//
//  MapViewController.m
//  DataMobile
//
//  Created by Zachary Patterson on 2/29/12.
//  Copyright (c) 2012 MML-Concordia. All rights reserved.
//

#import "MapViewController.h"
#import "DMAppDelegate.h"

@implementation MapViewController

@synthesize appDelegate;
@synthesize map;
@synthesize locations;

- (void)drawAllLocations
{
    CLLocationCoordinate2D* coordinates ;
    
    for (NSManagedObject* location in locations) 
    {
        coordinates[0].latitude = 39.281516 ;
        coordinates[0].longitude = -76.580806;
    }
    
    MKPolyline *polyLine = [MKPolyline polylineWithCoordinates:coordinates 
                                                         count:[locations count]];
    [map addOverlay:polyLine];
}

- (CLLocationCoordinate2D)getLastCoordinate
{
    // The locations are sorted in timestamp ascending order.
    NSManagedObject *lastLocation = [self.locations objectAtIndex:0];

    return CLLocationCoordinate2DMake([[lastLocation valueForKey:@"latitude"] doubleValue], 
                                      [[lastLocation valueForKey:@"longitude"] doubleValue]);
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
        
    CLLocationCoordinate2D coordinates[3];
        
    coordinates[0].latitude = 39.281516;
    coordinates[0].longitude = -76.580806;

    coordinates[1].latitude = 40.281516 ;
    coordinates[1].longitude = -76.580806;    
    
    coordinates[2].latitude = 41.281516 ;
    coordinates[2].longitude = -76.580806;
    
    MKPolyline *polyLine = [MKPolyline polylineWithCoordinates:coordinates 
                                                         count:3];
    [map addOverlay:polyLine];
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
    self.appDelegate = (DMAppDelegate*)[[UIApplication sharedApplication] delegate];
    self.locations = [appDelegate fetchAllLocations];
    
    self.map.delegate = self;    
}


- (void)viewDidUnload
{
    [self setMap:nil];
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
