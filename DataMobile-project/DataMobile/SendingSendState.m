//
//  SendingSendState.m
//  DataMobile
//
//  Created by Zachary Patterson on 1/17/12.
//  Copyright (c) 2012 MML-Concordia. All rights reserved.
//

#import "SendingSendState.h"
#import "MainViewController.h"

@implementation SendingSendState

- (void)executeForController:(MainViewController*)controller
{
    controller.dataButton.hidden = true;
    controller.sendingLabel.hidden = false; 
}

- (void)didSendDataForController:(MainViewController*)controller
{
    // impossible scenario
}

- (void)locationManagerDidUpdateForController:(MainViewController*)controller
{
    // do nothing
}

- (void)connectionDidFailForController:(MainViewController*)controller
{
    [self switchSendStateTo:@"SendableSendState" ForController:controller];
}

- (void)connectionDidReceiveDataWithErrorForController:(MainViewController*)controller
{
    [self switchSendStateTo:@"SendableSendState" ForController:controller];
}

- (void)connectionDidReceiveDataWithoutErrorForController:(MainViewController*)controller
{
    [self switchSendStateTo:@"NoSendState" ForController:controller];
}

@end
