//
//  MainViewController.h
//  Accelerometer Profiler
//
//  Created by Stan on 7/12/14.
//  Copyright (c) 2014 aspyrx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

@interface MainViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *xValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *yValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *zValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *rollValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *pitchValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *yawValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *mxValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *myValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *mzValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *accelLabel;
@property (weak, nonatomic) IBOutlet UILabel *gyroLabel;
@property (weak, nonatomic) IBOutlet UILabel *magnetoLabel;

- (IBAction)switchValueChanged:(UISwitch *)sender;

@end
