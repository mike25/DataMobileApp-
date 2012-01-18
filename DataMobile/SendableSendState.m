//
//  SendableSendState.m
//  DataMobile
//
//  Created by Zachary Patterson on 1/17/12.
//  Copyright (c) 2012 MML-Concordia. All rights reserved.
//

#import "SendableSendState.h"
#import "MainViewController.h"

@implementation SendableSendState

- (void)executeForController:(MainViewController*)controller
{
    controller.dataLabel.hidden = false;
    controller.dataButton.hidden = false;
    controller.sendingLabel.hidden = true; 
}

- (void)didSendDataForController:(MainViewController*)controller
{
    [self switchSendStateTo:@"SendingSendState" ForController:controller];
}

- (void)locationManagerDidUpdateForController:(MainViewController*)controller
{
    // do nothing
}

- (void)connectionDidFailForController:(MainViewController*)controller
{
    // impossible scenario
}

- (void)connectionDidReceiveDataWithErrorForController:(MainViewController*)controller
{
    // impossible scenario    
}

- (void)connectionDidReceiveDataWithoutErrorForController:(MainViewController*)controller
{
    // impossible scenario    
}

@end
