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

@end
