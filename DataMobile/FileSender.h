//
//  FileSender.h
//  DataMobile
//
//  Created by Kim Sawchuk on 11-11-27.
//  Copyright (c) 2011 MML-Concordia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileSender : NSObject <NSURLConnectionDelegate>

+ (void)sendString:(NSString*)string ToURL:(NSString*)url;

@end
