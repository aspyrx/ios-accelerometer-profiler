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

@interface Profile : NSObject {
    NSMutableData *data;
}

@property ProfileMetadata *metadata;
@property (readonly) NSData *data;

- (void)addMotionData:(CMDeviceMotion *)motion;

@end
