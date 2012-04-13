//
//  DatePickerController.h
//  DataMobile
//
//  Created by Kim Sawchuk on 11-11-28.
//  Copyright (c) 2011 MML-Concordia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DatePickerController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>
{
    @private NSInteger selectedNumOfDays;
}

@property (strong, nonatomic) IBOutlet UIPickerView *picker;
@property (strong, nonatomic) IBOutlet UILabel *pickerTitleLabel;

@property (strong, nonatomic) NSMutableArray* days;

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component;

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component;

-(void)pickerView:(UIPickerView *)pickerView 
     didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component;

- (IBAction)numberOfDaysSelected:(id)sender;

@end
