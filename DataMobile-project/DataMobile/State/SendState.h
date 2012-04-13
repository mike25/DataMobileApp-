//
//  SendState.h
//  DataMobile
//
//  Created by Zachary Patterson on 1/17/12.
//  Copyright (c) 2012 MML-Concordia. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MainViewController;

@interface SendState : NSObject

+(SendState*)determineInitialStateForController:(MainViewController*)controller;
+(SendState*)instanceOfState:(NSString*)stateClass;

-(void)switchSendStateTo:(NSString*)stateClass
           ForController:(MainViewController*)controller;

/*
 * Methods to be subclassed
 */
- (void)executeForController:(MainViewController*)controller;
- (void)didSendDataForController:(MainViewController*)controller;
- (void)locationManagerDidUpdateForController:(MainViewController*)controller;
- (void)connectionDidFailForController:(MainViewController*)controller;
- (void)connectionDidReceiveDataWithErrorForController:(MainViewController*)controller;
- (void)connectionDidReceiveDataWithoutErrorForController:(MainViewController*)controller;

@end