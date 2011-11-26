//
//  CSVExporter.h
//  GPSRecorder
//
//  Created by Kim Sawchuk on 11-11-23.
//  Copyright (c) 2011 MML-Concordia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSVExporter : NSObject

+(BOOL)exportObjects:(NSArray*)array toLocation:(NSString*)destination;

@end
