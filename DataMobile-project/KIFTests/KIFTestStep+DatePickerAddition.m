//
//  KIFTestStep+DatePickerAddition.m
//  DataMobile
//
//  Created by Zachary Patterson on 4/19/12.
//  Copyright (c) 2012 MML-Concordia. All rights reserved.
//

#import "KIFTestStep+DatePickerAddition.h"

#import "UIView-KIFAdditions.h"
#import "UIWindow-KIFAdditions.h"
#import "UIApplication-KIFAdditions.h"
#import "UIAccessibilityElement-KIFAdditions.h"

@implementation KIFTestStep (DatePickerAddition)

+(id)stepToSelectPickerViewRowWithTitle:(NSString *)title 
                           forComponent:(NSUInteger)componentIndex
{
    NSString *description = [NSString stringWithFormat:@"Select the \"%@\" item from the picker", title];
    
    return [self stepWithDescription:description 
                      executionBlock:^(KIFTestStep *step, NSError **error) 
            {                                        
                // Find the picker view
                UIPickerView *pickerView = (UIPickerView *)[[[UIApplication sharedApplication] pickerViewWindow] subviewWithClassNameOrSuperClassNamePrefix:@"UIPickerView"];                
                KIFTestCondition(pickerView, error, @"No picker view is present");
                
                NSInteger componentCount = [pickerView.dataSource numberOfComponentsInPickerView:pickerView];
                
                KIFTestCondition(componentIndex <= componentCount, error, @"The picker view does not have that many components; componentIndex == \"%@\", componentCount == \"%@\".", componentIndex, componentCount);
                NSInteger rowCount = [pickerView.dataSource pickerView:pickerView numberOfRowsInComponent:componentIndex];
                
                for (NSInteger rowIndex = 0; rowIndex < rowCount; rowIndex++) {
                    
                    NSString *rowTitle = nil;
                    if ([pickerView.delegate respondsToSelector:@selector(pickerView:titleForRow:forComponent:)]) {
                        
                        rowTitle = [pickerView.delegate pickerView:pickerView titleForRow:rowIndex forComponent:componentIndex];  
                        
                    } else if ([pickerView.delegate respondsToSelector:@selector(pickerView:viewForRow:forComponent:reusingView:)]) {
                        
                        // This delegate inserts views directly, so try to figure out what the title is by looking for a label
                        
                        UIView *rowView = [pickerView.delegate pickerView:pickerView viewForRow:rowIndex forComponent:componentIndex reusingView:nil];
                        
                        UILabel *label = (UILabel *)[rowView subviewWithClassNameOrSuperClassNamePrefix:@"UILabel"];
                        
                        rowTitle = label.text;
                        
                    }
                    
                    if ([rowTitle isEqual:title]) {
                        
                        [pickerView selectRow:rowIndex inComponent:componentIndex animated:YES];
                        
                        CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.5, false);
                        
                        // Tap in the middle of the picker view to select the item
                        
                        [pickerView tap];
                        
                        // The combination of selectRow:inComponent:animated: and tap does not consistently result in
                        
                        // pickerView:didSelectRow:inComponent: being called on the delegate. We need to do it explicitly.
                        
                        if ([pickerView.delegate respondsToSelector:@selector(pickerView:didSelectRow:inComponent:)]) {
                            
                            [pickerView.delegate pickerView:pickerView didSelectRow:rowIndex inComponent:componentIndex];
                            
                        }
                        return KIFTestStepResultSuccess;
                    }
                }
                
                KIFTestCondition(NO, error, @"Failed to find picker view value with title \"%@\"", title);
                
                return KIFTestStepResultFailure;
                
            }];
}
@end
