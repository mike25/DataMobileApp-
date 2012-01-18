//
//  NoSendState.m
//  DataMobile
//
//  Created by Zachary Patterson on 1/17/12.
//  Copyright (c) 2012 MML-Concordia. All rights reserved.
//

#import "NoSendState.h"
#import "MainViewController.h"

@implementation NoSendState

- (void)executeForController:(MainViewController*)controller
{
    controller.dataLabel.hidden = true;
    controller.dataButton.hidden = true;
    controller.sendingLabel.hidden = true; 
}

- (void)didSendDataForController:(MainViewController*)controller
{
    // impossible scenario
}

- (void)locationManagerDidUpdateForController:(MainViewController*)controller
{
    [self switchSendStateTo:@"SendableSendState" ForController:controller];
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
