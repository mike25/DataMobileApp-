//
//  CSVExporter.m
//  GPSRecorder
//
//  Created by Kim Sawchuk on 11-11-23.
//  Copyright (c) 2011 MML-Concordia. All rights reserved.
//

#import "CSVExporter.h"


@implementation CSVExporter 

+(NSString*)exportObjects:(NSArray*)array toLocation:(NSString*)destination
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];    
    NSString* filename = [documentsDirectory stringByAppendingPathComponent:destination];
    NSError* error;
    
    // Remove file if exists
    NSFileManager *filemgr = [NSFileManager defaultManager];
    if ([filemgr removeItemAtPath:filename error:&error]  == YES)
    {
        // Remove successfull
    }
    else
    {
        // Remove failed
    }
            
    NSString* titles = [[NSString alloc] initWithFormat:@"altitude, latitude, longitude, speed, direction, h_accuracy, v_accuracy, timestamp"];
    NSMutableString* locations = [[NSMutableString alloc] initWithFormat:@""];
    for (NSManagedObject *oneObject in array)
    {
        NSString* location = [NSString stringWithFormat:@"%@, %@, %@, %@, %@, %@, %@, %@\n",
                              [oneObject valueForKey:@"altitude"],
                              [oneObject valueForKey:@"latitude"],                              
                              [oneObject valueForKey:@"longitude"],
                              [oneObject valueForKey:@"speed"],
                              [oneObject valueForKey:@"direction"],
                              [oneObject valueForKey:@"h_accuracy"],
                              [oneObject valueForKey:@"v_accuracy"],
                              [oneObject valueForKey:@"timestamp"], nil ];
        
        [locations appendString:location];
    }
    
    [[NSString stringWithFormat:@"%@\n%@", titles, locations ] 
               writeToFile:filename 
                atomically:YES 
                  encoding:NSStringEncodingConversionAllowLossy 
                     error:&error];       
    return locations ;
}

@end
