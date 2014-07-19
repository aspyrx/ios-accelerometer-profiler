//
//  Profile.h
//  Accelerometer Profiler
//
//  Created by Stan on 7/15/14.
//  Copyright (c) 2014 aspyrx. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ProfileMetadata;
@class CMDeviceMotion;

@interface ProfileDataPoint : NSObject

@property NSTimeInterval timestamp;
@property double x;
@property double y;
@property double z;
@property double roll;
@property double pitch;
@property double yaw;

- (id)initWithTimestamp:(NSTimeInterval)timestamp x:(double)x y:(double)y z:(double)z roll:(double)roll pitch:(double)pitch yaw:(double)yaw;

+ (ProfileDataPoint *)dataPointWithTimestamp:(NSTimeInterval)timestamp x:(double)x y:(double)y z:(double)z roll:(double)roll pitch:(double)pitch yaw:(double)yaw;

@end

@interface Profile : NSObject {
    NSMutableArray *dataPoints;
}

@property ProfileMetadata *metadata;
@property (readonly) NSArray *dataPoints;
@property (readonly) NSData *data;

- (void)addMotion:(CMDeviceMotion *)motion;

+ (Profile *)profileFromFile:(NSString *)path;

@end
