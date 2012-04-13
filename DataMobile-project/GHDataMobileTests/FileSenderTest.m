//
//  FileSenderTest.m
//  DataMobile
//
//  Created by Kim Sawchuk on 11-12-10.
//  Copyright (c) 2011 MML-Concordia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SenTestingKit/SenTestingKit.h>

#import "FileSender.h"
#import "Config.h"

@interface SenderDelegate : NSObject <NSURLConnectionDataDelegate>

@property (nonatomic) BOOL didReceiveData;
@property (nonatomic) BOOL didReceiveError;

@property (strong, nonatomic) NSData* data;
@property (strong, nonatomic) NSError* error;

@end

@interface FileSenderTest : SenTestCase <NSURLConnectionDataDelegate>
{
@private FileSender* sender;
@private NSDictionary* postDico;
@private SenderDelegate* delegate;
}

@end

@implementation SenderDelegate

@synthesize didReceiveData;
@synthesize didReceiveError;
@synthesize data;
@synthesize error;

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
{
    self.didReceiveData = YES;
    self.data = data;
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    self.didReceiveError = YES;
    self.error = error;
}

@end

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
    [Config loadForFileName:@"config"];
    sender = [[FileSender alloc] init];
    postDico = [[NSDictionary alloc] initWithObjectsAndKeys:@"FAKE-ID-999", @"id",
                @"FAKE-TEXT-999", @"text" , nil];
    delegate = [[SenderDelegate alloc] init];
    delegate.didReceiveData = NO;
    delegate.didReceiveError = NO;
}

- (void)tearDown {
    // Run after each test method
}

/*
 * Wait 5 seconds (for the delegate's callback method to be invoked)
 */
- (void)wait5Seconds
{    
    NSDate *fiveSecondsFromNow = [NSDate dateWithTimeIntervalSinceNow:5.0];
    [[NSRunLoop currentRunLoop] runUntilDate:fiveSecondsFromNow];
    while (delegate.didReceiveData == NO && [fiveSecondsFromNow timeIntervalSinceNow] > 0) 
    {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:fiveSecondsFromNow];
    }
}

- (void)testSendPostData 
{
    NSString* url = [[Config instance] stringValueForKey:@"url"];
    STAssertNotNil(url, @"url could not have been determined.");
    
    [sender sendRequestWithPostData:postDico 
                              ToURL:url 
                       WithDelegate:delegate];
    
    [self wait5Seconds];
    
    STAssertFalse(delegate.didReceiveError, @"An Error occured : %@", [delegate.error description]);
    STAssertTrue(delegate.didReceiveData, @"The connection callback method has not been called.");
    
    NSString* data_response = [NSString stringWithUTF8String:[delegate.data bytes]];
    
    STAssertNotNil(data_response, @"server did not send a response");
    STAssertEqualObjects(data_response, @"Array\n(\n    [id] => FAKE-ID-999\n    [text] => FAKE-TEXT-999\n)"
                         , @"response returned by the server");
}

- (void)testSendPostDataWithBadPostBody
{
    NSString* url = [[Config instance] stringValueForKey:@"url-insert"];
    STAssertNotNil(url, @"url could not have been determined.");
    
    [sender sendRequestWithPostData:postDico 
                              ToURL:url 
                       WithDelegate:delegate];
    
    [self wait5Seconds];
    
    STAssertFalse(delegate.didReceiveError, @"An Error occured : %@", [delegate.error description]);
    STAssertTrue(delegate.didReceiveData, @"The connection callback method has not been called.");
    
    NSString* data_response = [NSString stringWithUTF8String:[delegate.data bytes]];
    STAssertNotNil(data_response, @"server did not send a response");
    
    // matching the server response to "An error occured during saving your data"
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"An error occured during saving your data"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:nil];
    NSTextCheckingResult *match = [regex firstMatchInString:data_response
                                                    options:0
                                                      range:NSMakeRange(0, [data_response length])];
    STAssertTrue(match, @"received server response did not match expected server response.");
    
}

@end