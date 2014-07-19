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
    
    // register for background notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    profile = [Profile new];
    deviceMotionUpdateInterval = kDeviceMotionUpdateIntervalMin;
    graphData = [NSMutableArray array];
    graphDataLock = [NSLock new];
    shouldUpdateGraphs = YES;
    
    mManager = [(AppDelegate *)[[UIApplication sharedApplication] delegate] sharedManager];
    
    // check that device motion is available
    if (![mManager isDeviceMotionAvailable]) {
        return;
    }
    
    // set initial update interval
    [mManager setDeviceMotionUpdateInterval:deviceMotionUpdateInterval];
    
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
    accelPlotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(0.0) length:CPTDecimalFromDouble(kDeviceMotionRange)];
    accelPlotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(-1.0) length:CPTDecimalFromDouble(2.0)];
    gyroPlotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(0.0) length:CPTDecimalFromDouble(kDeviceMotionRange)];
    gyroPlotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(-M_PI) length:CPTDecimalFromDouble(2 * M_PI)];
    
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
    return [graphData count];
}

- (double)doubleForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)idx {
    NSString *identifier = (NSString *)plot.identifier;
    CMDeviceMotion *motion = graphData[idx];
    if (fieldEnum == CPTScatterPlotFieldX) {
        CMDeviceMotion *first = [graphData firstObject];
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
    if (![mManager isDeviceMotionActive] && [mManager isDeviceMotionAvailable]) {
        // start device motion updates
        [mManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXTrueNorthZVertical toQueue:[NSOperationQueue new] withHandler:^(CMDeviceMotion *motion, NSError *error) {
            if (error) {
                NSLog(@"%@", error);
                return;
            }
            
            [graphDataLock lock];
            [graphData addObject:motion];
            CMDeviceMotion *first = [graphData firstObject];
            while (first != nil && motion.timestamp - first.timestamp > kDeviceMotionRange) {
                [graphData removeObjectAtIndex:0];
                first = [graphData firstObject];
            }
            [graphDataLock unlock];
            
            
            if (shouldUpdateGraphs) {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^(void) {
                    [graphDataLock lock];
                    [accelGraph reloadData];
                    [gyroGraph reloadData];
                    [graphDataLock unlock];
                }];
            }

            [profile addMotion:motion];
        }];
    }
    
    isRecording = YES;
    self.recordButton.enabled = NO;
    self.saveButton.enabled = YES;
}

- (void)stopRecording {
    if ([mManager isDeviceMotionActive]) {
        [mManager stopDeviceMotionUpdates];
    }

    isRecording = NO;
    self.recordButton.enabled = YES;
    self.saveButton.enabled = NO;
}

- (void)saveRecordingWithMetadata:(ProfileMetadata *)metadata {
    [self stopRecording];
    
    NSString *profilesDir = [NSHomeDirectory() stringByAppendingPathComponent:kProfilesDirectory];
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:profilesDir]) {
        NSError *error;
        [fm createDirectoryAtPath:profilesDir withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            NSLog(@"Error creating profiles directory: %@", error);
        }
    }
    
    profile.metadata = metadata;
    
    NSDateFormatter *df = [NSDateFormatter new];
    [df setDateFormat:kDateFormat];
    NSString *date = [df stringFromDate:profile.metadata.date];
    NSString *uuid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    NSString *filePath = [profilesDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@ %@.csv", date, uuid]];
    if (![[profile data] writeToFile:filePath atomically:NO]) {
        NSLog(@"Error writing profile to path: %@", filePath);
    }
    
    profile = [Profile new];
}

# pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"displaySaveModal"]) {
        SaveViewController *vc = segue.destinationViewController;
        [vc setDelegate:self];
    }
}

#pragma mark - Interface methods

- (IBAction)recordButtonPressed:(UIBarButtonItem *)sender {
    [self startRecording];
}

- (IBAction)updateIntervalValueChanged:(UIStepper *)sender {
    self.updateIntervalLabel.text = [NSString stringWithFormat:@"%.0f ms", sender.value];
    [self setDeviceMotionUpdateInterval:(sender.value / 1000)];
}

# pragma mark -

- (void)setDeviceMotionUpdateInterval:(NSTimeInterval)interval {
    deviceMotionUpdateInterval = MAX(kDeviceMotionUpdateIntervalMin, interval);
    [mManager setDeviceMotionUpdateInterval:deviceMotionUpdateInterval];
}

- (void)applicationDidEnterBackground {
    shouldUpdateGraphs = NO;
}

- (void)applicationWillEnterForeground {
    shouldUpdateGraphs = YES;
}

@end
