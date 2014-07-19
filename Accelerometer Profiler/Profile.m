//
//  Profile.m
//  Accelerometer Profiler
//
//  Created by Stan on 7/15/14.
//  Copyright (c) 2014 aspyrx. All rights reserved.
//

#import "Profile.h"
#import "ProfileMetadata.h"
#import "FileLineReader.h"
#import <CoreMotion/CoreMotion.h>

@implementation ProfileDataPoint

- (id)initWithTimestamp:(NSTimeInterval)timestamp x:(double)x y:(double)y z:(double)z roll:(double)roll pitch:(double)pitch yaw:(double)yaw {
    self = [super init];
    if (self) {
        self.timestamp = timestamp;
        self.x = x;
        self.y = y;
        self.z = z;
        self.roll = roll;
        self.pitch = pitch;
        self.yaw = yaw;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%f,%f,%f,%f,%f,%f,%f%@", self.timestamp, self.x, self.y, self.z, self.roll, self.pitch, self.yaw, kProfileLineDelimiter];
}

+ (ProfileDataPoint *)dataPointWithTimestamp:(NSTimeInterval)timestamp x:(double)x y:(double)y z:(double)z roll:(double)roll pitch:(double)pitch yaw:(double)yaw {
    return [[ProfileDataPoint alloc] initWithTimestamp:timestamp x:x y:y z:z roll:roll pitch:pitch yaw:yaw];
}

@end

@implementation Profile

@synthesize metadata, dataPoints;

- (id)init {
    self = [super init];
    if (self) {
        metadata = [ProfileMetadata new];
        dataPoints = [NSMutableArray array];
    }
    return self;
}

- (void)addDataPoint:(ProfileDataPoint *)dataPoint {
    [dataPoints addObject:dataPoint];
}

- (void)addMotion:(CMDeviceMotion *)motion {
    [self addDataPoint:[ProfileDataPoint dataPointWithTimestamp:motion.timestamp x:motion.userAcceleration.x y:motion.userAcceleration.y z:motion.userAcceleration.z roll:motion.attitude.roll pitch:motion.attitude.pitch yaw:motion.attitude.yaw]];
}

- (NSData *)data {
    NSMutableData *data = [NSMutableData dataWithData:[metadata data]];
    
    for (ProfileDataPoint *dataPoint in dataPoints) {
        [data appendData:[[dataPoint description] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    return data;
}

+ (Profile *)profileFromFile:(NSString *)path {
    FileLineReader *reader = [[FileLineReader alloc] initWithFilePath:path];
    if (!reader) {
        return nil;
    }
    
    ProfileMetadata *metadata = [ProfileMetadata new];
    
    NSDateFormatter *df = [NSDateFormatter new];
    [df setDateFormat:kDateFormat];
    metadata.date = [df dateFromString:[reader readLine]];
    metadata.name = [reader readLine];
    reader.lineDelimiter = [@"$DESC$" stringByAppendingString:kProfileLineDelimiter];
    metadata.notes = [reader readLine];
    reader.lineDelimiter = kProfileLineDelimiter;
    metadata.transportMode = [[reader readLine] intValue];
    
    Profile *profile = [Profile new];
    profile.metadata = metadata;
    
    NSNumberFormatter *nf = [NSNumberFormatter new];
    while (true) {
        NSString *line = [reader readLine];
        if (!line) {
            break;
        }
        
        NSMutableArray *vals = [[line componentsSeparatedByString:@","] mutableCopy];
        if ([vals count] == 7) {
            for (NSUInteger i = 0; i < [vals count]; i++) {
                vals[i] = [nf numberFromString:vals[i]];
            }
            
            [profile addDataPoint:[ProfileDataPoint dataPointWithTimestamp:[vals[0] doubleValue] x:[vals[1] doubleValue] y:[vals[2] doubleValue] z:[vals[3] doubleValue] roll:[vals[4] doubleValue] pitch:[vals[5] doubleValue] yaw:[vals[6] doubleValue]]];
        }
    }
    
    return profile;
}

@end
