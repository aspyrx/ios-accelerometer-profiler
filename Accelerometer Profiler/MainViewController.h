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
#import "RecordDataViewController.h"

@interface MainViewController : UIViewController <RecordingStartDelegate, CPTPlotDataSource> {
    CPTXYGraph *accelGraph;
    CPTXYGraph *gyroGraph;
    
    NSMutableArray *motionData;
}

@property (weak, nonatomic) IBOutlet UILabel *accelLabel;
@property (weak, nonatomic) IBOutlet UILabel *gyroLabel;
@property (weak, nonatomic) IBOutlet CPTGraphHostingView *accelGraphView;
@property (weak, nonatomic) IBOutlet CPTGraphHostingView *gyroGraphView;
@property (weak, nonatomic) IBOutlet UILabel *updateIntervalLabel;

- (IBAction)updateIntervalValueChanged:(UIStepper *)sender;

@end
