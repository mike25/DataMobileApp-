//
//  MapViewController.h
//  DataMobile
//
//  Created by Zachary Patterson on 2/29/12.
//  Copyright (c) 2012 MML-Concordia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@class DMAppDelegate;

@interface MapViewController : UIViewController <MKMapViewDelegate>

@property (weak, nonatomic) DMAppDelegate* appDelegate;
@property (strong, nonatomic) IBOutlet MKMapView *map;
@property (strong, nonatomic) NSArray* locations;

- (void)drawAllLocations;

/**
 *  Returns the last coordinate recorded on the database
 */
- (CLLocationCoordinate2D)getLastCoordinate;

@end
