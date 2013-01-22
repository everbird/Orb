//
//  AppContext+RestKit.h
//  Orb
//
//  Created by everbird on 11/9/12.
//  Copyright (c) 2012 everbird. All rights reserved.
//

#import "AppContext.h"

#import <RestKit/RestKit.h>

@interface AppContext (RestKit)

@property (nonatomic, readonly) RKObjectManager* objectManager;
@property (nonatomic, strong) RKObjectManager* syncObjectManager;
@property (nonatomic, readonly) AFHTTPClient* client;
@property (nonatomic, readonly) NSOperationQueue* operationQueue;
@property (nonatomic, strong) RKManagedObjectImporter* importer;
@property (nonatomic, strong) RKEntityMapping* programMapping;

- (void)suspend;
- (void)unsuspend;

@end
