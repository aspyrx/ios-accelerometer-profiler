//
//  ProfileMetadata.m
//  Accelerometer Profiler
//
//  Created by Stan on 7/17/14.
//  Copyright (c) 2014 aspyrx. All rights reserved.
//

#import "ProfileMetadata.h"
#import "FileLineReader.h"

@implementation ProfileMetadata

- (NSData *)data {
    return [self.description dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)description {
    NSDateFormatter *df = [NSDateFormatter new];
    [df setDateFormat:kDateFormat];
    return [NSString stringWithFormat:@"%@%@%@%@%@$DESC$%@%d%@", [df stringFromDate:self.date], kProfileLineDelimiter, self.name, kProfileLineDelimiter, self.notes, kProfileLineDelimiter, self.transportMode, kProfileLineDelimiter];
}

+ (ProfileMetadata *)metadataFromFile:(NSString *)path {
    FileLineReader *reader = [[FileLineReader alloc] initWithFilePath:path];
    if (!reader) {
        return nil;
    }
    
    ProfileMetadata *metadata = [ProfileMetadata new];
    
    NSDateFormatter *df = [NSDateFormatter new];
    [df setDateFormat:kDateFormat];
    metadata.date = [df dateFromString:[reader readLine]];
    metadata.name = [reader readLine];
    reader.lineDelimiter = [kProfileLineDelimiter stringByAppendingString:@"$DESC$"];
    metadata.notes = [reader readLine];
    reader.lineDelimiter = kProfileLineDelimiter;
    metadata.transportMode = [[reader readLine] intValue];
    
    return metadata;
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
        case TransportModeOther:
            return @"Other";
        default:
            return nil;
    }
}

@end
