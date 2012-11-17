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
    RKURL* rkUrl = [RKURL URLWithString:SEER_API_BASE_URL];
    objectManager.client.baseURL = rkUrl;
//    objectManager.client.cachePolicy = RKRequestCachePolicyNone;
    return objectManager;
}

- (RKClient*)client
{
    return self.objectManager.client;
}

- (RKRequestQueue*)requestQueue
{
    return self.client.requestQueue;
}

- (void)suspend
{
    NSLog(@"suspend");
    self.requestQueue.suspended = YES;
}

- (void)unsuspend
{
    NSLog(@"unsuspend");
    self.requestQueue.suspended = NO;
}

@end
