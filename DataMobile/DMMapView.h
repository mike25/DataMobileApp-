//
//  DMMapView.h
//  DataMobile
//
//  Created by Zachary Patterson on 3/28/12.
//  Copyright (c) 2012 MML-Concordia. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface DMMapView : MKMapView <MKMapViewDelegate>

@property (strong, nonatomic) NSArray* myLocations;

/**
 * Draws the passed array of MyMapAnnotation on the map
 */
- (void)drawLocations:(NSArray*)newLocations;

- (void)centerToRegion:(MKCoordinateRegion)region;

/**
 *  Returns the last coordinate recorded on the database
 */
- (CLLocationCoordinate2D)getLastCoordinate;

/**
 * Remove from the passed array of locations locations that are both
 * close in time and space and return the resulting array.
 */
+ (NSArray*)reduceLocations:(NSArray*)locations;

+ (CLLocationCoordinate2D*)locationsToCoordinates:(NSArray*)locations;

@end
