//
//  ProfileDataViewController.m
//  Accelerometer Profiler
//
//  Created by Stan on 7/19/14.
//  Copyright (c) 2014 aspyrx. All rights reserved.
//

#import "ProfileDataViewController.h"
#import "Profile.h"

static NSString *kAccelXPlotIdentifier = @"accelX";
static NSString *kAccelYPlotIdentifier = @"accelY";
static NSString *kAccelZPlotIdentifier = @"accelZ";
static NSString *kGyroRollPlotIdentifier = @"gyroRoll";
static NSString *kGyroPitchPlotIdentifier = @"gyroPitch";
static NSString *kGyroYawPlotIdentifier = @"gyroYaw";

@interface ProfileDataViewController ()

@end

@implementation ProfileDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.profile) {
        return;
    }
    
    graphData = self.profile.dataPoints;
    
    // set up graphs
    accelGraph = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
    gyroGraph = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
    
    self.accelGraphView.collapsesLayers = NO;
    self.gyroGraphView.collapsesLayers = NO;
    self.accelGraphView.hostedGraph = accelGraph;
    self.gyroGraphView.hostedGraph = gyroGraph;
    
    accelGraph.paddingLeft = 0.0;
    accelGraph.paddingTop = 0.0;
    accelGraph.paddingRight = 0.0;
    accelGraph.paddingBottom = 0.0;
    
    gyroGraph.paddingLeft = 0.0;
    gyroGraph.paddingTop = 0.0;
    gyroGraph.paddingRight = 0.0;
    gyroGraph.paddingBottom = 0.0;
    
    // plot space
    CPTXYPlotSpace *accelPlotSpace = (CPTXYPlotSpace *)accelGraph.defaultPlotSpace;
    CPTXYPlotSpace *gyroPlotSpace = (CPTXYPlotSpace *)gyroGraph.defaultPlotSpace;
    accelPlotSpace.allowsUserInteraction = YES;
    gyroPlotSpace.allowsUserInteraction = YES;
    accelPlotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(0.0) length:CPTDecimalFromDouble(10.0)];
    accelPlotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(-1.0) length:CPTDecimalFromDouble(2.0)];
    gyroPlotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(0.0) length:CPTDecimalFromDouble(10.0)];
    gyroPlotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(-M_PI) length:CPTDecimalFromDouble(2 * M_PI)];
    
    // axes
    CPTMutableLineStyle *majorGridLineStyle = [CPTMutableLineStyle lineStyle];
    CPTMutableLineStyle *minorGridLineStyle = [CPTMutableLineStyle lineStyle];
    majorGridLineStyle.lineColor = [CPTColor colorWithComponentRed:0.0f green:0.0f blue:0.0f alpha:0.2f];
    minorGridLineStyle.lineColor = [CPTColor colorWithComponentRed:0.0f green:0.0f blue:0.0f alpha:0.1f];
    
    CPTXYAxisSet *accelAxisSet = (CPTXYAxisSet *)accelGraph.axisSet;
    CPTXYAxis *accelX = accelAxisSet.xAxis;
    CPTXYAxis *accelY = accelAxisSet.yAxis;
    accelX.majorIntervalLength = CPTDecimalFromDouble(5.0);
    accelX.orthogonalCoordinateDecimal = CPTDecimalFromDouble(0.0);
    accelX.minorTicksPerInterval = 4;
    accelX.majorGridLineStyle = majorGridLineStyle;
    accelX.minorGridLineStyle = minorGridLineStyle;
    
    accelY.majorIntervalLength = CPTDecimalFromDouble(0.5);
    accelY.minorTicksPerInterval = 1;
    accelY.orthogonalCoordinateDecimal = CPTDecimalFromDouble(0.0);
    accelY.majorGridLineStyle = majorGridLineStyle;
    accelY.minorGridLineStyle = minorGridLineStyle;
    
    CPTXYAxisSet *gyroAxisSet = (CPTXYAxisSet *)gyroGraph.axisSet;
    CPTXYAxis *gyroX = gyroAxisSet.xAxis;
    CPTXYAxis *gyroY = gyroAxisSet.yAxis;
    gyroX.majorIntervalLength = CPTDecimalFromDouble(5.0);
    gyroX.orthogonalCoordinateDecimal = CPTDecimalFromDouble(0.0);
    gyroX.minorTicksPerInterval = 4;
    gyroX.majorGridLineStyle = majorGridLineStyle;
    gyroX.minorGridLineStyle = minorGridLineStyle;
    
    gyroY.majorIntervalLength = CPTDecimalFromDouble(M_PI_2);
    gyroY.minorTicksPerInterval = 1;
    gyroY.orthogonalCoordinateDecimal = CPTDecimalFromDouble(0.0);
    gyroY.majorGridLineStyle = majorGridLineStyle;
    gyroY.minorGridLineStyle = minorGridLineStyle;
    
    // plots
    CPTMutableLineStyle *xLineStyle = [CPTMutableLineStyle lineStyle];
    CPTMutableLineStyle *yLineStyle = [CPTMutableLineStyle lineStyle];
    CPTMutableLineStyle *zLineStyle = [CPTMutableLineStyle lineStyle];
    xLineStyle.lineColor = [CPTColor redColor];
    yLineStyle.lineColor = [CPTColor greenColor];
    zLineStyle.lineColor = [CPTColor blueColor];
    
    CPTScatterPlot *accelXPlot = [CPTScatterPlot new];
    CPTScatterPlot *accelYPlot = [CPTScatterPlot new];
    CPTScatterPlot *accelZPlot = [CPTScatterPlot new];
    accelXPlot.identifier = kAccelXPlotIdentifier;
    accelYPlot.identifier = kAccelYPlotIdentifier;
    accelZPlot.identifier = kAccelZPlotIdentifier;
    accelXPlot.dataSource = self;
    accelYPlot.dataSource = self;
    accelZPlot.dataSource = self;
    accelXPlot.dataLineStyle = xLineStyle;
    accelYPlot.dataLineStyle = yLineStyle;
    accelZPlot.dataLineStyle = zLineStyle;
    [accelGraph addPlot:accelXPlot];
    [accelGraph addPlot:accelYPlot];
    [accelGraph addPlot:accelZPlot];
    
    CPTScatterPlot *gyroRollPlot = [CPTScatterPlot new];
    CPTScatterPlot *gyroPitchPlot = [CPTScatterPlot new];
    CPTScatterPlot *gyroYawPlot = [CPTScatterPlot new];
    gyroRollPlot.identifier = kGyroRollPlotIdentifier;
    gyroPitchPlot.identifier = kGyroPitchPlotIdentifier;
    gyroYawPlot.identifier = kGyroYawPlotIdentifier;
    gyroRollPlot.dataSource = self;
    gyroPitchPlot.dataSource = self;
    gyroYawPlot.dataSource = self;
    gyroRollPlot.dataLineStyle = xLineStyle;
    gyroPitchPlot.dataLineStyle = yLineStyle;
    gyroYawPlot.dataLineStyle = zLineStyle;
    [gyroGraph addPlot:gyroRollPlot];
    [gyroGraph addPlot:gyroPitchPlot];
    [gyroGraph addPlot:gyroYawPlot];
}

#pragma mark - CPTPlotDataSource

- (NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
    return [graphData count];
}

- (double)doubleForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)idx {
    NSString *identifier = (NSString *)plot.identifier;
    ProfileDataPoint *dataPoint = graphData[idx];
    if (fieldEnum == CPTScatterPlotFieldX) {
        ProfileDataPoint *first = [graphData firstObject];
        return dataPoint.timestamp - first.timestamp;
    } else {
        if ([identifier isEqualToString:kAccelXPlotIdentifier]) {
            return dataPoint.x;
        } else if ([identifier isEqualToString:kAccelYPlotIdentifier]) {
            return dataPoint.y;
        } else if ([identifier isEqualToString:kAccelZPlotIdentifier]) {
            return dataPoint.z;
        } else if ([identifier isEqualToString:kGyroRollPlotIdentifier]) {
            return dataPoint.roll;
        } else if ([identifier isEqualToString:kGyroPitchPlotIdentifier]) {
            return dataPoint.pitch;
        } else if ([identifier isEqualToString:kGyroYawPlotIdentifier]) {
            return dataPoint.yaw;
        }
    }
    
    return 0;
}

@end
