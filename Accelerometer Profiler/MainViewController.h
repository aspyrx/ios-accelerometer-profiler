//
//  MainViewController.h
//  Accelerometer Profiler
//
//  Created by Stan on 7/12/14.
//  Copyright (c) 2014 aspyrx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#import "CorePlot-CocoaTouch.h"
#import "ProfileMetadata.h"
#import "Profile.h"

@interface MainViewController : UIViewController <ProfileRecorder, CPTPlotDataSource> {
    CPTXYGraph *accelGraph;
    CPTXYGraph *gyroGraph;
    NSTimeInterval deviceMotionUpdateInterval;
    CMMotionManager *mManager;
    Profile *profile;
    NSMutableArray *graphData;
    NSLock *graphDataLock;
    BOOL shouldUpdateGraphs;
}

@property (weak, nonatomic) IBOutlet UILabel *accelLabel;
@property (weak, nonatomic) IBOutlet UILabel *gyroLabel;
@property (weak, nonatomic) IBOutlet CPTGraphHostingView *accelGraphView;
@property (weak, nonatomic) IBOutlet CPTGraphHostingView *gyroGraphView;
@property (weak, nonatomic) IBOutlet UILabel *updateIntervalLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *recordButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;

- (IBAction)updateIntervalValueChanged:(UIStepper *)sender;

@end
