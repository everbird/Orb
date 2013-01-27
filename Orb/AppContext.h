//
//  AppContext.h
//  Orb
//
//  Created by everbird on 11/6/12.
//  Copyright (c) 2012 everbird. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DBCredential.h"

#define appContext ((AppContext *)[AppContext sharedContext])

@interface AppContext : NSObject

@property (nonatomic, weak) UINavigationController* rootVC;

@property (nonatomic, readonly) DBCredential* credential;

+ (id)sharedContext;

@end
