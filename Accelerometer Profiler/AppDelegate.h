//
//  AppDelegate.h
//  Accelerometer Profiler
//
//  Created by Stan on 7/12/14.
//  Copyright (c) 2014 aspyrx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic, readonly) CMMotionManager *sharedManager;

@end
