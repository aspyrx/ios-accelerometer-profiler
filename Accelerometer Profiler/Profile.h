//
//  Profile.h
//  Accelerometer Profiler
//
//  Created by Stan on 7/15/14.
//  Copyright (c) 2014 aspyrx. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    TransportModeWalk = 0,
    TransportModeBicycle,
    TransportModeCar,
    TransportModeBus,
    TransportModeSubway,
    TransportModeTrain,
    TRANSPORT_MODE_ENUM_SIZE
} transport_mode_t;

@interface Profile : NSObject

@property NSString *name;
@property NSString *notes;
@property transport_mode_t transportMode;

+ (NSString *)nameForTransportMode:(transport_mode_t)mode;

@end

@protocol ProfileRecorder <NSObject>

@property (readonly) BOOL isRecording;

- (void)startRecording;
- (void)stopRecording;
- (void)saveRecordingWithProfile:(Profile *)profile;

@end
