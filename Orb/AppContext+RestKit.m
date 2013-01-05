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

- (RKObjectManager*)objectManager
{
    RKObjectManager* objectManager = [RKObjectManager sharedManager];
    return objectManager;
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
