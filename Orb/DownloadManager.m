//
//  DownloadManager.m
//  Orb
//
//  Created by everbird on 1/23/13.
//  Copyright (c) 2013 everbird. All rights reserved.
//

#import "DownloadManager.h"

#import <AFDownloadRequestOperation/AFDownloadRequestOperation.h>
#import <SSZipArchive/SSZipArchive.h>

#import "AppContext+RestKit.h"
#import "AppContext+Data.h"

@implementation DownloadManager

+ (void)downloadByDatenumber:(NSString*)datenumber WithBlock:(void (^)(NSInteger bytesRead, long long totalBytesRead, long long totalBytesExpected, long long totalBytesReadForFile, long long totalBytesExpectedToReadForFile))block
{
    NSString* tempDir = NSTemporaryDirectory();
    NSString *urlStr = [NSString stringWithFormat:@"http://seer.everbird.net/packages/daily-programs-%@.json.gz", datenumber];
    NSString* tempFilePath = [tempDir stringByAppendingString:[NSString stringWithFormat:@"daily-programs-%@.json.gz", datenumber]];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:3600];
    
    AFDownloadRequestOperation *operation = [[AFDownloadRequestOperation alloc] initWithRequest:request targetPath:tempFilePath shouldResume:YES];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Successfully downloaded file to %@", tempFilePath);
        NSString* dest = [tempFilePath substringToIndex:[tempFilePath length] - 3];
        NSLog(@"dest: %@", dest);
        
        NSData* sourceData = [NSData dataWithContentsOfFile:tempFilePath];
        NSData* targetData = [self uncompressZippedData:sourceData];
        
        [targetData writeToFile:dest atomically:YES];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:dest]) {
            //Clean data first
            [appContext deleteByDatenum:datenumber];
            
            // Start import data
            NSError* importerError;
            [appContext.importer importObjectsFromItemAtPath:dest
                                                 withMapping:appContext.programMapping
                                                     keyPath:@"objects"
                                                       error:&importerError];
            NSError* finishError;
            BOOL finish = [appContext.importer finishImporting:&finishError];
            NSLog(@"Finish: %d, Import error: %@", finish, finishError);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    [operation setProgressiveDownloadProgressBlock:block];
    [operation start];
}

+ (NSData *)uncompressZippedData:(NSData *)compressedData
{
    
    if ([compressedData length] == 0) return compressedData;
    
    unsigned full_length = [compressedData length];
    
    unsigned half_length = [compressedData length] / 2;
    NSMutableData *decompressed = [NSMutableData dataWithLength: full_length + half_length];
    BOOL done = NO;
    int status;
    z_stream strm;
    strm.next_in = (Bytef *)[compressedData bytes];
    strm.avail_in = [compressedData length];
    strm.total_out = 0;
    strm.zalloc = Z_NULL;
    strm.zfree = Z_NULL;
    if (inflateInit2(&strm, (15+32)) != Z_OK) return nil;
    while (!done) {
        // Make sure we have enough room and reset the lengths.
        if (strm.total_out >= [decompressed length]) {
            [decompressed increaseLengthBy: half_length];
        }
        strm.next_out = [decompressed mutableBytes] + strm.total_out;
        strm.avail_out = [decompressed length] - strm.total_out;
        // Inflate another chunk.
        status = inflate (&strm, Z_SYNC_FLUSH);
        if (status == Z_STREAM_END) {
            done = YES;
        } else if (status != Z_OK) {
            break;
        }
        
    }
    if (inflateEnd (&strm) != Z_OK) return nil;
    // Set real length.
    if (done) {
        [decompressed setLength: strm.total_out];
        return [NSData dataWithData: decompressed];
    } else {
        return nil;
    }    
}

@end
