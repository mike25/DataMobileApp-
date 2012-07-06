//
//  MapViewController.h
//  DataMobile
//
//  Created by Zachary Patterson on 2/29/12.
//  Copyright (c) 2012 MML-Concordia. All rights reserved.
//adding code 

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class DMMapView;
@class CoreDataHelper;

@interface MapViewController : UIViewController

@property (weak, nonatomic) CoreDataHelper* cdHelper;

@property (strong, nonatomic) NSDate* startDate;
@property (strong, nonatomic) NSDate* endDate;

@property (strong, nonatomic) IBOutlet DMMapView *map;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (strong, nonatomic) IBOutlet UIButton *goButton;

- (IBAction)startEndValueChanged:(id)sender;
- (IBAction)dateValueChanged:(id)sender;
- (IBAction)goButtonTouched:(id)sender;

@end
