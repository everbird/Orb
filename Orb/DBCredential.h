//
//  DBCredential.h
//  DoubanOauth2Authentication
//
//  Created by everbird on 11/1/12.
//  Copyright (c) 2012 everbird. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBCredential : NSObject

@property (nonatomic, readonly) NSString* accessToken;
@property (nonatomic, readonly) NSString* refreshToken;
@property (nonatomic, readonly) NSString* userId;
@property (nonatomic, readonly) NSNumber* expireIn;
@property (nonatomic, readonly) NSDate* authorizeDate;

@property (nonatomic, readonly) BOOL isValid;
@property (nonatomic, readonly) BOOL isExpired;
@property (nonatomic, readonly) NSDate* expireDate;

- (void)invalidate;
- (void)reload;
- (void)updateAccessToken:(NSString *)newAccessToken
             refreshToken:(NSString *)newRefreshToken
                 expireIn:(NSNumber*)newExpireIn
            authorizeDate:(NSDate*)newAuthorizeDate
                   userId:(NSString*)newUserId;

@end
