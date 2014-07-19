//
//  ProfileDataViewController.h
//  Accelerometer Profiler
//
//  Created by Stan on 7/19/14.
//  Copyright (c) 2014 aspyrx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"

@class Profile;

@interface ProfileDataViewController : UIViewController <CPTPlotDataSource> {
    CPTXYGraph *accelGraph;
    CPTXYGraph *gyroGraph;
    
    NSArray *graphData;
}

@property (weak, nonatomic) IBOutlet CPTGraphHostingView *accelGraphView;
@property (weak, nonatomic) IBOutlet CPTGraphHostingView *gyroGraphView;
@property (strong) Profile *profile;

@end
