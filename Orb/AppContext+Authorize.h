//
//  AppContext+Authorize.h
//  Orb
//
//  Created by everbird on 1/27/13.
//  Copyright (c) 2013 everbird. All rights reserved.
//

#import "AppContext.h"

#import "AppCommon.h"


@interface AppContext (Authorize)


- (void)loginWithUsername:(NSString*)username
                 password:(NSString*)password
                  success:(ZZFinishedBlock)success
                   failed:(ZZFailedBlock)failed;
- (void)logoutWithBlock:(ZZRunBlock)completion;
- (void)refreshTokenOnSuccess:(ZZFinishedBlock)success
                       failed:(ZZFailedBlock)failed;

@end
