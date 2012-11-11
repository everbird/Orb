//
//  AppContext.m
//  Orb
//
//  Created by everbird on 11/6/12.
//  Copyright (c) 2012 everbird. All rights reserved.
//

#import "AppContext.h"

@implementation AppContext

#pragma mark - Singleton Methods

+ (id)sharedContext
{
    static AppContext* sharedContext = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedContext = [[self alloc] init];
    });
    return sharedContext;
}

@end
