//
//  FileSender.h
//  DataMobile
//
//  Created by Kim Sawchuk on 11-11-27.
//  Copyright (c) 2011 MML-Concordia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileSender : NSObject <NSURLConnectionDelegate>

@property (strong,nonatomic) NSError* error;
@property (strong,nonatomic) NSString* responseString;

-(void)sendPostData:(NSDictionary*)dico ToURL:(NSString*)url;

/**
* Code Taken and modified from : git://gist.github.com/916845.git
* Put a query string onto the end of a url
*/
+(NSString*)addQueryStringToUrl:(NSString*)url params:(NSDictionary *)params;

@end
