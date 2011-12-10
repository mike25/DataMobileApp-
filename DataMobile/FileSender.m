    //
//  FileSender.m
//  DataMobile
//
//  Created by Kim Sawchuk on 11-11-27.
//  Copyright (c) 2011 MML-Concordia. All rights reserved.
//

#import "FileSender.h"


@implementation FileSender

+ (void)sendPostData:(NSDictionary*)dico ToURL:(NSString*)url
{
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    request.HTTPMethod = @"POST" ;
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    
    // adding Post Parameters to the request.
    NSString* requestString = [NSString stringWithFormat:[FileSender addQueryStringToUrl:@"" params:dico]]; 
    NSData* data = [NSData dataWithBytes:[requestString UTF8String] length:[requestString length]];    
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

/**
 * Code Taken and modified from : git://gist.github.com/916845.git
 * Put a query string onto the end of a url
 */
+(NSString*)addQueryStringToUrl:(NSString*)url params:(NSDictionary *)params 
{
	NSMutableString *urlWithQuerystring = [[NSMutableString alloc] initWithString:url];
	// Convert the params into a query string
	if (params) 
    {
        BOOL first = true;
		for(id key in params) 
        {
			NSString *sKey = [key description];
			NSString *sVal = [[params objectForKey:key] description];
		
            // Do we need to add k=v or &k=v ?
			if (first) 
            {
				[urlWithQuerystring appendFormat:@"%@=%@", sKey, sVal];
                first = false ;
			} 
            else 
            {
				[urlWithQuerystring appendFormat:@"&%@=%@", sKey, sVal];
			}
		}
	}
	return urlWithQuerystring;
}

@end
