//
//  AppContext+Download.h
//  Orb
//
//  Created by everbird on 1/21/13.
//  Copyright (c) 2013 everbird. All rights reserved.
//

#import "AppContext.h"

@interface AppContext (Download)

- (void)downloadByDatenumber:(NSString*)datenumber WithBlock:(void (^)(NSInteger bytesRead, long long totalBytesRead, long long totalBytesExpected, long long totalBytesReadForFile, long long totalBytesExpectedToReadForFile))block
;

@end
