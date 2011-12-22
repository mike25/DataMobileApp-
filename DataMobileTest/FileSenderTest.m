//
//  FileSenderTest.m
//  DataMobile
//
//  Created by Kim Sawchuk on 11-12-10.
//  Copyright (c) 2011 MML-Concordia. All rights reserved.
//

#import "FileSenderTest.h"
#import "FileSender.h"
#import "Config.h"

#import <UIKit/UIKit.h>

@implementation FileSenderTest

// All code under test is in the iOS Application
- (void)testAppDelegate
{
    id yourApplicationDelegate = [[UIApplication sharedApplication] delegate];
    STAssertNotNil(yourApplicationDelegate, @"UIApplication failed to find the AppDelegate");
}

- (void)setUp 
{
    // Run before each test method
    sender = [[FileSender alloc] init];
    postDico = [[NSDictionary alloc] initWithObjectsAndKeys:@"FAKE-ID-999", @"id",
                                                           @"FAKE-TEXT-999", @"text" , nil];
}

- (void)tearDown {
    // Run after each test method
}

- (void)testSendPostData 
{
    NSString* url = [[Config loadForFileName:@"config-test"] stringValueForKey:@"url"];
    STAssertNotNil(url, @"url could not have been determined.");
    [sender sendPostData:postDico ToURL:url];
    
    STAssertNotNil(sender.responseString, @"sender contains the response sent by the server.");
    STAssertEqualObjects(sender.responseString, @"Array\n(\n    [id] => FAKE-ID-999\n    [text] => FAKE-TEXT-999\n)", @"response returned by the server");
}

@end
