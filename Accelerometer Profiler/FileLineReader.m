//
//  DDFileReader.m
//  Accelerometer Profiler
//
//  Created by Stan on 7/17/14.
//  Copyright (c) 2014 aspyrx. All rights reserved.
//

#import "FileLineReader.h"

/*
@interface NSData (DDAdditions)

- (NSRange)rangeOfData_dd:(NSData *)dataToFind;

@end

@implementation NSData (DDAdditions)

- (NSRange)rangeOfData_dd:(NSData *)dataToFind {
    const void *bytes = [self bytes];
    NSUInteger len = [self length];
    
    const void *searchBytes = [dataToFind bytes];
    NSUInteger searchLen = [dataToFind length];
    
    NSUInteger j = 0;
    NSRange range = {NSNotFound, searchLen};
    for (NSUInteger i = 0; i < len; i++) {
        if (((char *)bytes)[i] == ((char *)searchBytes)[j]) {
            if (range.location == NSNotFound) {
                range.location = i;
            }
            j++;
            if (j >= searchLen) {
                return range;
            }
        } else {
            j = 0;
            range.location = NSNotFound;
        }
    }
    return range;
}

@end
*/

@implementation FileLineReader

@synthesize lineDelimiter, chunkSize;

- (id)initWithFilePath:(NSString *)aPath {
    self = [super init];
    if (self) {
        fh = [NSFileHandle fileHandleForReadingAtPath:aPath];
        if (!fh) {
            return nil;
        }
        
        path = aPath;
        lineDelimiter = @"\r\n";
        offset = 0ULL;
        chunkSize = 256;
        [fh seekToEndOfFile];
        len = [fh offsetInFile];
    }
    return self;
}

- (void)dealloc {
    [fh closeFile];
}

- (NSString *)readLineUntrimmed {
    if (offset >= len) {
        return nil;
    }
    
    NSData *delimData = [lineDelimiter dataUsingEncoding:NSUTF8StringEncoding];
    [fh seekToFileOffset:offset];
    NSMutableData *data = [NSMutableData data];
    
    BOOL shouldRead = YES;
    while (shouldRead) {
        if (offset >= len) {
            break;
        }
        
        NSData *chunk = [fh readDataOfLength:chunkSize];
        NSRange delimRange = [chunk rangeOfData:delimData options:0 range:NSMakeRange(0, [chunk length])];
        if (delimRange.location != NSNotFound) {
            chunk = [chunk subdataWithRange:NSMakeRange(0, delimRange.location + [delimData length])];
            shouldRead = NO;
        }
        [data appendData:chunk];
        offset += [chunk length];
    }
    
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (NSString *)readLine {
    NSString *s = [self readLineUntrimmed];
    return (s ? [s substringWithRange:NSMakeRange(0, [s length] - [lineDelimiter length])] : nil);
}

@end
