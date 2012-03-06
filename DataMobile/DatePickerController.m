//
//  DatePickerController.m
//  DataMobile
//
//  Created by Kim Sawchuk on 11-11-28.
//  Copyright (c) 2011 MML-Concordia. All rights reserved.
//

#import "DatePickerController.h"
#import "Config.h"

@implementation DatePickerController 

@synthesize picker;
@synthesize pickerTitleLabel;
@synthesize days;

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    return [days count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    return  [[days objectAtIndex:row] stringValue];
}

-(void)pickerView:(UIPickerView *)pickerView 
     didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
    selectedNumOfDays = [[days objectAtIndex:row] intValue];
}

- (IBAction)numberOfDaysSelected:(id)sender 
{
    [self.navigationController popViewControllerAnimated:YES];
    NSDictionary* dico = [[NSDictionary alloc] initWithObjectsAndKeys: [[NSNumber alloc] initWithInteger:selectedNumOfDays],
                                                                        @"numOfDays", nil];    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NumberOfDaysInputSelected" 
                                                        object:self
                                                      userInfo:dico];
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
    
    int max_period = [[Config instance] integerValueForKey:@"maxRecordingPeriod"];
    
    self.pickerTitleLabel.text = [NSString stringWithFormat:@"Enter number of days (max = %d)"
                                                            , max_period];
    
    days = [[NSMutableArray alloc] initWithCapacity:max_period];
    
    // Default Value ;    
    selectedNumOfDays = 1 ;
    for(int i = 1; i <= max_period ; i++)
    {
        [days insertObject:[NSNumber numberWithInt:i] atIndex:i-1];
    }
    picker.dataSource = self;
    picker.delegate = self;
}


- (void)viewDidUnload
{
    [self setPicker:nil];
    [self setPickerTitleLabel:nil];
    
    self.days = nil;
    
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
