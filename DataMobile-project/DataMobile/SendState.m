//
//  SendState.m
//  DataMobile
//
//  Created by Zachary Patterson on 1/17/12.
//  Copyright (c) 2012 MML-Concordia. All rights reserved.
//

#import "SendState.h"
#import "DMAppDelegate.h"
#import "CoreDataHelper.h"
#import "MainViewController.h"

@implementation SendState

/*
 * returns : _SendableState if condition is true
 *           _NoSendState if condition is false
 */
+(SendState*)determineInitialStateForController:(MainViewController*)controller
{
    // Checking if there is any data to send
    NSArray* locations = [controller.appDelegate.cdataHelper fetchLocationsFromPosition:0
                                                                                  limit:1 ];
    
    NSString* classString = ([locations count] > 0) ?  @"SendableSendState" : @"NoSendState" ;
    return [SendState instanceOfState:classString];
}

+(SendState*)instanceOfState:(NSString*)stateClass
{
    Class klass = NSClassFromString(stateClass);
    return (SendState*)[[klass alloc] init];
}

-(void)switchSendStateTo:(NSString*)stateClass
           ForController:(MainViewController*)controller
{
    SendState* newState = [SendState instanceOfState:stateClass];
    [newState executeForController:controller];
    controller.sendState = newState;
}

- (void)executeForController:(MainViewController*)controller
{
    [NSException raise:NSInternalInconsistencyException 
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
}
- (void)didSendDataForController:(MainViewController*)controller
{
    [NSException raise:NSInternalInconsistencyException 
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
}
- (void)locationManagerDidUpdateForController:(MainViewController*)controller
{
    [NSException raise:NSInternalInconsistencyException 
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
}
- (void)connectionDidFailForController:(MainViewController*)controller
{
    [NSException raise:NSInternalInconsistencyException 
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
}
- (void)connectionDidReceiveDataWithErrorForController:(MainViewController*)controller
{
    [NSException raise:NSInternalInconsistencyException 
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
}
- (void)connectionDidReceiveDataWithoutErrorForController:(MainViewController*)controller
{
    [NSException raise:NSInternalInconsistencyException 
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
}

@end
