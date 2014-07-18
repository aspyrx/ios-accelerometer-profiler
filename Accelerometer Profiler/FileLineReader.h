//
//  DDFileReader.h
//  Accelerometer Profiler
//
//  Created by Stan on 7/17/14.
//  Copyright (c) 2014 aspyrx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileLineReader : NSObject {
    NSString *path;
    NSFileHandle *fh;
    unsigned long long offset;
    unsigned long long len;
    
    NSString *lineDelimiter;
    NSUInteger chunkSize;
}

@property (nonatomic, copy) NSString *lineDelimiter;
@property (nonatomic) NSUInteger chunkSize;

- (id)initWithFilePath:(NSString *)aPath;

- (NSString *)readLineUntrimmed;
- (NSString *)readLine;

@end
