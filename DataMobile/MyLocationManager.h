//
//  MyLocationManager.h
//  DataMobile
//
//  Created by Kim Sawchuk on 11-11-28.
//  Copyright (c) 2011 MML-Concordia. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MyLocationManagerObserver <NSObject>

@optional
- (void)managerStarted;
- (void)managerStopped;
- (void)didUpdateToLocation:(CLLocation *)newLocation;
- (void)didFailWithError:(NSError *)error;

@end

typedef enum 
{
    STARTED = 1,
    STOPPED = 2,
    UPDATE = 3,
    FAIl = 4
}  ObserverAction ;

@interface MyLocationManager : NSObject <CLLocationManagerDelegate>

@property (strong, nonatomic) NSMutableArray* observers;
@property (strong,  nonatomic) CLLocationManager* manager;

- (void)startManager;
- (void)stopManager;

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation 
           fromLocation:(CLLocation *)oldLocation;

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error;

/*
 * Helper Methods 
 */
- (void)notifyObserversForStartAction;
- (void)notifyObserversForStopAction;
- (void)notifyObserversForUpdateActionWithLocation:(CLLocation *)newLocation;
- (void)notifyObserversForFailActionWithError:(NSError *)error;

@end
