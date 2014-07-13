//
//  GraphsViewController.h
//  Accelerometer Profiler
//
//  Created by Stan on 7/13/14.
//  Copyright (c) 2014 aspyrx. All rights reserved.
//

#import "CorePlot-CocoaTouch.h"
#import <UIKit/UIKit.h>

@interface GraphsViewController : UIViewController <CPTPlotDataSource, CPTAxisDelegate> {
    CPTXYGraph *graph;
}

@end
