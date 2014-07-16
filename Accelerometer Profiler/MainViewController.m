//
//  MainViewController.m
//  Accelerometer Profiler
//
//  Created by Stan on 7/12/14.
//  Copyright (c) 2014 aspyrx. All rights reserved.
//

#import "MainViewController.h"
#import "AppDelegate.h"
#import "SaveViewController.h"

static const NSTimeInterval kDeviceMotionUpdateIntervalMin = 0.05;
static const NSTimeInterval kDeviceMotionRange = 10.0;
static const NSTimeInterval kGraphReloadIntervalMin = 0.05;

static NSString *kAccelXPlotIdentifier = @"accelX";
static NSString *kAccelYPlotIdentifier = @"accelY";
static NSString *kAccelZPlotIdentifier = @"accelZ";
static NSString *kGyroRollPlotIdentifier = @"gyroRoll";
static NSString *kGyroPitchPlotIdentifier = @"gyroPitch";
static NSString *kGyroYawPlotIdentifier = @"gyroYaw";

@interface MainViewController ()

@end

@implementation MainViewController

@synthesize isRecording;

# pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    CMMotionManager *mManager = [(AppDelegate *)[[UIApplication sharedApplication] delegate] sharedManager];
    
    // check that device motion is available
    if (![mManager isDeviceMotionAvailable]) {
        return;
    }
    
    // set initial update interval
    [mManager setDeviceMotionUpdateInterval:kDeviceMotionUpdateIntervalMin];
    
    // initialize data array
    motionData = [NSMutableArray new];
    
    // remove "unavailable" message
    self.accelLabel.text = @"Accelerometer";
    self.accelLabel.textColor = [UIColor darkTextColor];
    self.gyroLabel.text = @"Gyroscope";
    self.gyroLabel.textColor = [UIColor darkTextColor];
    
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
    accelPlotSpace.allowsUserInteraction = NO;
    gyroPlotSpace.allowsUserInteraction = NO;
    accelPlotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0) length:CPTDecimalFromFloat(kDeviceMotionRange)];
    accelPlotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-1.0) length:CPTDecimalFromFloat(2.0)];
    gyroPlotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0) length:CPTDecimalFromFloat(kDeviceMotionRange)];
    gyroPlotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-M_PI) length:CPTDecimalFromFloat(2 * M_PI)];
    
    // axes
    CPTMutableLineStyle *majorGridLineStyle = [CPTMutableLineStyle lineStyle];
    CPTMutableLineStyle *minorGridLineStyle = [CPTMutableLineStyle lineStyle];
    majorGridLineStyle.lineColor = [CPTColor colorWithComponentRed:0.0f green:0.0f blue:0.0f alpha:0.2f];
    minorGridLineStyle.lineColor = [CPTColor colorWithComponentRed:0.0f green:0.0f blue:0.0f alpha:0.1f];
    
    CPTXYAxisSet *accelAxisSet = (CPTXYAxisSet *)accelGraph.axisSet;
    CPTXYAxis *accelX = accelAxisSet.xAxis;
    CPTXYAxis *accelY = accelAxisSet.yAxis;
    accelX.majorIntervalLength = CPTDecimalFromDouble(2 * kDeviceMotionRange);
    accelX.orthogonalCoordinateDecimal = CPTDecimalFromDouble(0.0);
    accelX.minorTicksPerInterval = 2 * ceil(kDeviceMotionRange) - 1;
    accelX.majorGridLineStyle = majorGridLineStyle;
    accelX.minorGridLineStyle = minorGridLineStyle;
    accelX.labelAlignment = CPTAlignmentRight;
    
    accelY.majorIntervalLength = CPTDecimalFromDouble(0.5);
    accelY.minorTicksPerInterval = 1;
    accelY.orthogonalCoordinateDecimal = CPTDecimalFromDouble(0.0);
    accelY.majorGridLineStyle = majorGridLineStyle;
    accelY.minorGridLineStyle = minorGridLineStyle;
    
    CPTXYAxisSet *gyroAxisSet = (CPTXYAxisSet *)gyroGraph.axisSet;
    CPTXYAxis *gyroX = gyroAxisSet.xAxis;
    CPTXYAxis *gyroY = gyroAxisSet.yAxis;
    gyroX.majorIntervalLength = CPTDecimalFromDouble(2 * kDeviceMotionRange);
    gyroX.orthogonalCoordinateDecimal = CPTDecimalFromDouble(0.0);
    gyroX.minorTicksPerInterval = 2 * ceil(kDeviceMotionRange) - 1;
    gyroX.majorGridLineStyle = majorGridLineStyle;
    gyroX.minorGridLineStyle = minorGridLineStyle;
    gyroX.labelAlignment = CPTAlignmentRight;
    
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

# pragma mark - CPTPlotDataSource

- (NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
    return [motionData count];
}

- (double)doubleForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)idx {
    NSString *identifier = (NSString *)plot.identifier;
    CMDeviceMotion *motion = (CMDeviceMotion *)[motionData objectAtIndex:idx];
    if (fieldEnum == CPTScatterPlotFieldX) {
        CMDeviceMotion *first = (CMDeviceMotion *)[motionData firstObject];
        return motion.timestamp - first.timestamp;
    } else {
        if ([identifier isEqualToString:kAccelXPlotIdentifier]) {
            return motion.userAcceleration.x;
        } else if ([identifier isEqualToString:kAccelYPlotIdentifier]) {
            return motion.userAcceleration.y;
        } else if ([identifier isEqualToString:kAccelZPlotIdentifier]) {
            return motion.userAcceleration.z;
        } else if ([identifier isEqualToString:kGyroRollPlotIdentifier]) {
            return motion.attitude.roll;
        } else if ([identifier isEqualToString:kGyroPitchPlotIdentifier]) {
            return motion.attitude.pitch;
        } else if ([identifier isEqualToString:kGyroYawPlotIdentifier]) {
            return motion.attitude.yaw;
        }
    }
    
    return 0;
}

# pragma mark - ProfileRecorder

- (void)startRecording {
    CMMotionManager *mManager = [(AppDelegate *)[[UIApplication sharedApplication] delegate] sharedManager];
    
    if (![mManager isDeviceMotionActive] && [mManager isDeviceMotionAvailable]) {
        [mManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXTrueNorthZVertical toQueue:[NSOperationQueue currentQueue] withHandler:^(CMDeviceMotion *motion, NSError *error) {
            if (error != nil) {
                NSLog(@"Error: %@", error);
                return;
            }
            
            [motionData addObject:motion];
            CMDeviceMotion *d = [motionData firstObject];
            while (motion.timestamp - d.timestamp > kDeviceMotionRange) {
                [motionData removeObjectAtIndex:0];
                d = [motionData firstObject];
            }
        }];
        
        // start updating graph
        graphReloadTimer = [NSTimer timerWithTimeInterval:MAX(kGraphReloadIntervalMin, deviceMotionUpdateInterval) target:self selector:@selector(reloadGraphs) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:graphReloadTimer forMode:NSDefaultRunLoopMode];
    }
    
    isRecording = YES;
}

- (void)stopRecording {
    CMMotionManager *mManager = [(AppDelegate *)[[UIApplication sharedApplication] delegate] sharedManager];
    
    if ([mManager isDeviceMotionActive]) {
        [mManager stopDeviceMotionUpdates];
    }
    
    // stop updating graph
    [graphReloadTimer invalidate];
    
    isRecording = NO;
}

- (void)saveRecordingWithProfile:(Profile *)profile {
    if (!profile) {
        return;
    }
    
    NSLog(@"%@ | %@ | %d", profile.name, profile.notes, profile.transportMode);
}

# pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"displaySaveModal"]) {
        SaveViewController *vc = (SaveViewController *)segue.destinationViewController;
        [vc setDelegate:self];
    }
}

#pragma mark - Interface methods

- (IBAction)updateIntervalValueChanged:(UIStepper *)sender {
    self.updateIntervalLabel.text = [NSString stringWithFormat:@"%.0f ms", sender.value];
    [self setDeviceMotionUpdateInterval:(sender.value / 1000)];
}

# pragma mark -

- (void)reloadGraphs {
    [accelGraph reloadData];
    [gyroGraph reloadData];
}

- (void)setDeviceMotionUpdateInterval:(NSTimeInterval)interval {
    CMMotionManager *mManager = [(AppDelegate *)[[UIApplication sharedApplication] delegate] sharedManager];
    
    deviceMotionUpdateInterval = MAX(kDeviceMotionUpdateIntervalMin, interval);
    [mManager setDeviceMotionUpdateInterval:deviceMotionUpdateInterval];
}

@end
