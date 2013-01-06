//
//  AppContext+RestKit.m
//  Orb
//
//  Created by everbird on 11/9/12.
//  Copyright (c) 2012 everbird. All rights reserved.
//

#import "AppContext+RestKit.h"

#import "AppCommon.h"

@implementation AppContext (RestKit)

@dynamic syncObjectManager;

NSString* const kSyncObjectManager = @"kSyncObjectManager";

- (RKObjectManager*)objectManager
{
    RKObjectManager* objectManager = [RKObjectManager sharedManager];
    return objectManager;
}

- (void)setSyncObjectManager:(RKObjectManager *)syncObjectManager
{
    objc_setAssociatedObject(self, (__bridge const void *)(kSyncObjectManager), syncObjectManager, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (RKObjectManager*)syncObjectManager
{
    id obj = objc_getAssociatedObject(self, (__bridge const void *)(kSyncObjectManager));
    if (!obj) {
        obj = [self loadTodayProgramsFromLocal];
        [self setSyncObjectManager:obj];
    }
    return obj;
}

- (AFHTTPClient*)client
{
    return self.objectManager.HTTPClient;
}

- (NSOperationQueue*)operationQueue
{
    return self.client.operationQueue;
}

- (void)suspend
{
    NSLog(@"suspend");
    [self.operationQueue setSuspended:YES];
}

- (void)unsuspend
{
    NSLog(@"unsuspend");
    [self.operationQueue setSuspended:NO];
}

@end
