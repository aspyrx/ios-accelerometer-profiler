//
//  AppDelegate.m
//  Accelerometer Profiler
//
//  Created by Stan on 7/12/14.
//  Copyright (c) 2014 aspyrx. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate () {
    CMMotionManager *motionManager;
    CLLocationManager *locationManager;
}
@end

@implementation AppDelegate

- (CMMotionManager *)sharedMotionManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        motionManager = [[CMMotionManager alloc] init];
    });
    return motionManager;
}

- (CLLocationManager *)sharedLocationManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        locationManager = [[CLLocationManager alloc] init];
    });
    return locationManager;
}

@end
