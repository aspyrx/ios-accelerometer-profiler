//
//  Profile.m
//  Accelerometer Profiler
//
//  Created by Stan on 7/15/14.
//  Copyright (c) 2014 aspyrx. All rights reserved.
//

#import "Profile.h"

@implementation Profile

@synthesize name, notes, transportMode;

- (id)init {
    self = [super init];
    if (self) {
        name = [NSString new];
        notes = [NSString new];
        transportMode = TRANSPORT_MODE_ENUM_SIZE;
    }
    return self;
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
