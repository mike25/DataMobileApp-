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

@interface MapViewController : UIViewController <MKMapViewDelegate>

@property (weak, nonatomic) CoreDataHelper* cdHelper;
@property (strong, nonatomic) NSArray* annotations;

@property (strong, nonatomic) NSDate* startDate;
@property (strong, nonatomic) NSDate* endDate;

@property (strong, nonatomic) IBOutlet MKMapView *map;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (strong, nonatomic) IBOutlet UIButton *goButton;

/**
 * Draws the passed array of MyMapAnnotation on the map
 */
- (void)drawLocations:(NSArray*)newLocations;

/**
 * Draws locations that have been recorded from startDate to EndDate
 */
- (void)drawLocationsForStartDate:(NSDate*)start WithEndDate:(NSDate*)end;

/**
 *  Returns the last coordinate recorded on the database
 */
- (CLLocationCoordinate2D)getLastCoordinate:(NSArray*)locations;

- (IBAction)startEndValueChanged:(id)sender;
- (IBAction)dateValueChanged:(id)sender;
- (IBAction)goButtonTouched:(id)sender;

@end
