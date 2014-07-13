//
//  MainViewController.m
//  Accelerometer Profiler
//
//  Created by Stan on 7/12/14.
//  Copyright (c) 2014 aspyrx. All rights reserved.
//

#import "MainViewController.h"
#import "AppDelegate.h"

static const NSTimeInterval deviceMotionInterval = 0.03;

@interface MainViewController ()

@end

@implementation MainViewController

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

# pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    CMMotionManager *mManager = [(AppDelegate *)[[UIApplication sharedApplication] delegate] sharedManager];
    
    if ([mManager isDeviceMotionAvailable]) {
        self.accelLabel.text = @"Accelerometer";
        self.accelLabel.textColor = [UIColor darkTextColor];
        self.gyroLabel.text = @"Gyroscope";
        self.gyroLabel.textColor = [UIColor darkTextColor];
    }
}

# pragma mark - Interface methods

- (IBAction)switchValueChanged:(UISwitch *)sender {
    CMMotionManager *mManager = [(AppDelegate *)[[UIApplication sharedApplication] delegate] sharedManager];
    
    if (!sender.isOn) {
        if ([mManager isDeviceMotionActive]) {
            [mManager stopDeviceMotionUpdates];
        }
    } else {
        if (![mManager isDeviceMotionActive] && [mManager isDeviceMotionAvailable]) {
            [mManager setDeviceMotionUpdateInterval:deviceMotionInterval];
            [mManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXTrueNorthZVertical toQueue:[NSOperationQueue currentQueue] withHandler:^(CMDeviceMotion *motion, NSError *error) {
                if (error != nil) {
                    NSLog(@"Error: %@", error);
                    return;
                }
                
                self.xValueLabel.text = [NSString stringWithFormat:@"%.6f G", motion.userAcceleration.x];
                self.yValueLabel.text = [NSString stringWithFormat:@"%.6f G", motion.userAcceleration.y];
                self.zValueLabel.text = [NSString stringWithFormat:@"%.6f G", motion.userAcceleration.z];
                
                self.rollValueLabel.text = [NSString stringWithFormat:@"%.6f rad", motion.attitude.roll];
                self.pitchValueLabel.text = [NSString stringWithFormat:@"%.6f rad", motion.attitude.pitch];
                self.yawValueLabel.text = [NSString stringWithFormat:@"%.6f rad", motion.attitude.yaw];
            }];
        }
    }
}

@end
