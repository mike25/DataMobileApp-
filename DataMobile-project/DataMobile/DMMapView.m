//
//  DMMapView.m
//  DataMobile
//
//  Created by Zachary Patterson on 3/28/12.
//  Copyright (c) 2012 MML-Concordia. All rights reserved.
//

#import "DMMapView.h"
#import "MyMapAnnotation.h"

@implementation DMMapView

static const double limitSeconds = 2000;
static const double limitMeters = 2000;

@synthesize myLocations;

- (void)drawLocations:(NSArray*)newLocations
{
    if ([newLocations count] == 0) 
    {
        NSLog(@"there is nothing to show.");       
        return;
    }
    
    /* deleting past Routes */
    [self removeAnnotations:self.annotations];
    [self removeOverlays:self.overlays];
    
    /* drawing new Route */
    NSLog(@"before : %i", [newLocations count]);
    newLocations = [DMMapView reduceLocations:newLocations];
    NSLog(@"after : %i", [newLocations count]);
    
    CLLocationCoordinate2D* coordinates = [DMMapView locationsToCoordinates:newLocations];
    MKPolyline *polyLine = [MKPolyline polylineWithCoordinates:coordinates
                                                         count:[newLocations count]];
    [self addOverlay:polyLine];
    free(coordinates);
    
    //Add start and end annotations
    MyMapAnnotation* first_notation = (MyMapAnnotation*)[newLocations objectAtIndex:[newLocations count]-1];
    MyMapAnnotation* last_notation = (MyMapAnnotation*)[newLocations objectAtIndex:0];
    [first_notation setName:@"End Point"];
    [last_notation setName:@"Start Point"];
    [self addAnnotation:first_notation];
    [self addAnnotation:last_notation];
    [self selectAnnotation:first_notation animated:YES];
    
    // Setting region to point to the start coordinate
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance([first_notation coordinate], 0.5*1609, 0.5*1609);
    MKCoordinateRegion adjustedRegion = [self regionThatFits:viewRegion];                
    [self setRegion:adjustedRegion animated:YES];
    
    myLocations = newLocations;
}

- (void)centerToRegion:(MKCoordinateRegion)region
{
    MKCoordinateRegion adjustedRegion = [self regionThatFits:region];                
    [self setRegion:adjustedRegion animated:YES];
}

+(NSArray *)reduceLocations:(NSArray *)locations
{    
    NSMutableArray* strippedLocations = [[NSMutableArray alloc] init];
    for (int i = 0; i < [locations count]; i++)
    {
        MyMapAnnotation* note = (MyMapAnnotation*)[locations objectAtIndex:i];
        
        if (i == 0)
        {
            [strippedLocations addObject:[locations objectAtIndex:i]];
        }        
        else
        {
            BOOL conflicts = NO;
            for (MyMapAnnotation* st_note in strippedLocations)
            {
                CLRegion *region = [[CLRegion alloc] initCircularRegionWithCenter:[st_note coordinate]
                                                                           radius:limitMeters
                                                                       identifier:@"none"];
                NSDate* previousStamp = [(MyMapAnnotation*)[locations objectAtIndex:(i-1)] timeStamp];
                
                if ([region containsCoordinate:[note coordinate]]
                    && abs([note.timeStamp timeIntervalSinceDate:previousStamp]) < limitSeconds) 
                {
                    conflicts = YES;
                    break;
                }            
            }
            if (!conflicts) 
            {
                [strippedLocations addObject:note];
            }
        }        
    }    
        
    return strippedLocations;
}

+ (CLLocationCoordinate2D*)locationsToCoordinates:(NSArray*)strippedLocations
{        
    CLLocationCoordinate2D* coordinates = malloc(sizeof(CLLocationCoordinate2D)*[strippedLocations count]);
    
    for (int i = 0; i < [strippedLocations count]; i++)
    {
        coordinates[i] = [[strippedLocations objectAtIndex:i] coordinate];        
    }    
    
    return coordinates;
}

- (CLLocationCoordinate2D)getLastCoordinate
{
    // The locations are sorted in timestamp ascending order.
    MyMapAnnotation *lastLocation = (MyMapAnnotation*)[self.myLocations objectAtIndex:0];
    return [lastLocation coordinate];
}

# pragma mark - Annotation

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {	
	
    if (annotation == mapView.userLocation) 
    { 
        //returning nil means 'use built in location view'
		return nil;
	}
	
	MKPinAnnotationView *pinAnnotation = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"Pin"];
    
	if (pinAnnotation == nil) {
		pinAnnotation = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Pin"];
	} else {
		pinAnnotation.annotation = annotation;
	}
	
    pinAnnotation.canShowCallout = YES;
	pinAnnotation.pinColor = MKPinAnnotationColorRed;
	pinAnnotation.animatesDrop = YES;
	
	return pinAnnotation;
}

# pragma mark - MKMapViewDelegate

-(MKOverlayView*)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay
{
	if ([overlay isKindOfClass:[MKPolyline class]]) {
		
		MKPolylineView *polylineView = [[MKPolylineView alloc] initWithPolyline:overlay];
		polylineView.strokeColor = [UIColor blueColor];
		polylineView.lineWidth = 2.0;
		return polylineView;
	}
	
	return [[MKOverlayView alloc] initWithOverlay:overlay];
}


@end
