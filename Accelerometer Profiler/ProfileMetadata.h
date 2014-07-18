//
//  ProfileMetadata.h
//  Accelerometer Profiler
//
//  Created by Stan on 7/17/14.
//  Copyright (c) 2014 aspyrx. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *kProfilesDirectory = @"Documents/Profiles/";
static NSString *kProfileLineDelimiter = @"\r\n";
static NSString *kDateFormat = @"yyyy.MM.dd HH.mm.ss Z";
static NSString *kDateFormatDisplay = @"EEE, MMM d, YYYY h:mm a";

@interface ProfileMetadata : NSObject

typedef enum {
    TransportModeWalk = 0,
    TransportModeBicycle,
    TransportModeCar,
    TransportModeBus,
    TransportModeSubway,
    TransportModeTrain,
    TransportModeOther,
    TRANSPORT_MODE_ENUM_SIZE
} transport_mode_t;

@property NSDate *date;
@property NSString *name;
@property NSString *notes;
@property transport_mode_t transportMode;
@property (readonly) NSData *data;

+ (NSString *)nameForTransportMode:(transport_mode_t)mode;
+ (ProfileMetadata *)metadataFromFile:(NSString *)path;

@end

@protocol ProfileRecorder <NSObject>

@property (readonly) BOOL isRecording;

- (void)startRecording;
- (void)stopRecording;
- (void)saveRecordingWithMetadata:(ProfileMetadata *)metadata;

@end
