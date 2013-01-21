//
//  AppContext+Download.m
//  Orb
//
//  Created by everbird on 1/21/13.
//  Copyright (c) 2013 everbird. All rights reserved.
//

#import "AppContext+Download.h"

#import <AFDownloadRequestOperation/AFDownloadRequestOperation.h>

@implementation AppContext (Download)

- (void)downloadByDatenumber:(NSString*)datenumber WithBlock:(void (^)(NSInteger bytesRead, long long totalBytesRead, long long totalBytesExpected, long long totalBytesReadForFile, long long totalBytesExpectedToReadForFile))block
{
    NSString* tempDir = NSTemporaryDirectory();
    NSString *urlStr = [NSString stringWithFormat:@"http://seer.everbird.net/packages/daily-programs-%@.json.gz", datenumber];
    NSString* tempFilePath = [tempDir stringByAppendingString:[NSString stringWithFormat:@"daily-programs-%@.json.gz", datenumber]];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:3600];
    
    AFDownloadRequestOperation *operation = [[AFDownloadRequestOperation alloc] initWithRequest:request targetPath:tempFilePath shouldResume:YES];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Successfully downloaded file to %@", tempFilePath);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    [operation setProgressiveDownloadProgressBlock:block];
    [operation start];
}

@end
