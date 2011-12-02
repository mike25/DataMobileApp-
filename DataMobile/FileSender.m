//
//  FileSender.m
//  DataMobile
//
//  Created by Kim Sawchuk on 11-11-27.
//  Copyright (c) 2011 MML-Concordia. All rights reserved.
//

#import "FileSender.h"


@implementation FileSender

+ (void)sendString:(NSString*)string ToURL:(NSString*)url
{
    NSURL *urlObject = [NSURL URLWithString:url];    
    NSString* requestString = [NSString stringWithFormat:@"text=%@", string];    
    NSData* data = [NSData dataWithBytes:[requestString UTF8String] length:[requestString length]];
    
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:urlObject];
    request.HTTPMethod = @"POST" ;
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    request.HTTPBody = data;
                
    NSURLResponse* response;
    NSError *error ;
    
    NSData* returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString* returnString = [NSString stringWithUTF8String:[returnData bytes]];
    
    
    if (!error) 
    {
        NSLog(@"%@", returnString);
    }
}

@end
