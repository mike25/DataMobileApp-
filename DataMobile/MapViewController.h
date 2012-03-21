//
//  MapViewController.h
//  DataMobile
//
//  Created by Zachary Patterson on 2/29/12.
//  Copyright (c) 2012 MML-Concordia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class CoreDataHelper;

@interface MapViewController : UIViewController <MKMapViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) CoreDataHelper* cdHelper;
@property (strong, nonatomic) IBOutlet MKMapView *map;
@property (strong, nonatomic) NSArray* annotations;

/**
 * Draws the passed array of MyMapAnnotation on the map
 */
- (void)drawLocations:(NSArray*)newLocations;

/**
 *  Returns the last coordinate recorded on the database
 */
- (CLLocationCoordinate2D)getLastCoordinate:(NSArray*)locations;

@end
