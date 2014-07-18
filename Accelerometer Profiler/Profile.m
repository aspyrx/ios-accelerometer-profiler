//
//  Profile.m
//  Accelerometer Profiler
//
//  Created by Stan on 7/15/14.
//  Copyright (c) 2014 aspyrx. All rights reserved.
//

#import "Profile.h"
#import "ProfileMetadata.h"
#import <CoreMotion/CoreMotion.h>

@implementation Profile

@synthesize metadata;

- (id)init {
    self = [super init];
    if (self) {
        metadata = [ProfileMetadata new];
        data = [NSMutableData data];
    }
    return self;
}

- (void)addMotionData:(CMDeviceMotion *)motion {
    [data appendData:[[NSString stringWithFormat:@"%f,%f,%f,%f,%f,%f,%f%@", motion.timestamp, motion.userAcceleration.x, motion.userAcceleration.y, motion.userAcceleration.z, motion.attitude.roll, motion.attitude.pitch, motion.attitude.yaw, kProfileLineDelimiter] dataUsingEncoding:NSUTF8StringEncoding]];
}

- (NSData *)data {
    NSMutableData *newData = [NSMutableData dataWithData:[metadata data]];
    [newData appendData:data];
    
    return newData;
}

@end
