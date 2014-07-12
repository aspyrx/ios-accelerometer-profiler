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
}
@end

@implementation AppDelegate

- (CMMotionManager *)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        motionManager = [[CMMotionManager alloc] init];
    });
    return motionManager;
}

@end
