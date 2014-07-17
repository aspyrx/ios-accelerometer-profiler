//
//  Profile.m
//  Accelerometer Profiler
//
//  Created by Stan on 7/15/14.
//  Copyright (c) 2014 aspyrx. All rights reserved.
//

#import "Profile.h"
#import <CoreMotion/CoreMotion.h>

@implementation Profile

@synthesize name, notes, transportMode;

- (id)init {
    self = [super init];
    if (self) {
        name = [NSString new];
        notes = [NSString new];
        transportMode = TRANSPORT_MODE_ENUM_SIZE;
        data = [NSMutableData data];
    }
    return self;
}

- (void)addMotionData:(CMDeviceMotion *)motion {
    [data appendData:[[NSString stringWithFormat:@"%f,%f,%f,%f,%f,%f,%f\r\n", motion.timestamp, motion.userAcceleration.x, motion.userAcceleration.y, motion.userAcceleration.z, motion.attitude.roll, motion.attitude.pitch, motion.attitude.yaw] dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES]];
}

- (NSData *)data {
    if (!(name && notes && transportMode != TRANSPORT_MODE_ENUM_SIZE && data)) {
        return nil;
    }
    
    NSMutableData *newData = [NSMutableData dataWithData:[[NSString stringWithFormat:@"%@\r\n%@\r\n%d\r\n", name, notes, transportMode] dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES]];
    [newData appendData:data];
    
    return newData;
}

+ (NSString *)nameForTransportMode:(transport_mode_t)mode {
    switch (mode) {
        case TransportModeWalk:
            return @"Walk";
        case TransportModeBicycle:
            return @"Bicycle";
        case TransportModeCar:
            return @"Car";
        case TransportModeBus:
            return @"Bus";
        case TransportModeSubway:
            return @"Subway";
        case TransportModeTrain:
            return @"Train";
        default:
            return nil;
    }
}

@end
