//
//  DBCredential.m
//  DoubanOauth2Authentication
//
//  Created by everbird on 11/1/12.
//  Copyright (c) 2012 everbird. All rights reserved.
//

#import "DBCredential.h"
#import <Security/Security.h>


static NSString* const kDBCredentialAccessTokenKey = @"access_token";
static NSString* const kDBCredentialRefreshTokenKey = @"refresh_token";
static NSString* const kDBCredentialUserIdKey = @"user_id";
static NSString* const kDBCredentialExpireInKey = @"expire_in";
static NSString* const kDBCredentialAuthorizeDateKey = @"authorize_date";

@interface DBCredential (KeyChain)
- (NSString *)serviceName;
- (NSMutableDictionary *)keychainQuery:(NSString *)identifier;
- (NSString *)stringForKey:(NSString *)key;
- (void)setString:(NSString *)string forKey:(NSString *)key;
- (void)removeObjectForKey:(NSString *)key;

@end

@implementation DBCredential

- (BOOL)isValid
{
    return NO && _accessToken && _refreshToken;
}

- (BOOL)isExpired
{
    NSDate* now = [NSDate new];
    return [now compare:self.expireDate] == NSOrderedDescending;
}

- (NSDate*)expireDate
{
    return [_authorizeDate dateByAddingTimeInterval:[_expireIn intValue]];
}

- (void)invalidate
{
    NSLog(@"credential invalidated");
    [self updateAccessToken:nil
               refreshToken:nil
                   expireIn:nil
              authorizeDate:nil
                     userId:nil];
}

- (void)reload
{
    _accessToken = nil;
    _refreshToken = nil;
    _expireIn = nil;
    _authorizeDate = nil;
    _userId = nil;
    _accessToken = [[self stringForKey:kDBCredentialAccessTokenKey] copy];
    _refreshToken = [[self stringForKey:kDBCredentialRefreshTokenKey] copy];
    _userId = [[self stringForKey:kDBCredentialUserIdKey] copy];
    _expireIn = [[[NSUserDefaults standardUserDefaults] objectForKey:kDBCredentialExpireInKey] copy];
    _authorizeDate = [[[NSUserDefaults standardUserDefaults] objectForKey:kDBCredentialAuthorizeDateKey] copy];
}

- (void)updateAccessToken:(NSString *)newAccessToken
             refreshToken:(NSString *)newRefreshToken
                 expireIn:(NSNumber*)newExpireIn
            authorizeDate:(NSDate*)newAuthorizeDate
                   userId:(NSString*)newUserId
{
    _accessToken = [newAccessToken copy];
    _refreshToken = [newRefreshToken copy];
    _userId = [newUserId copy];
    _expireIn = [newExpireIn copy];
    _authorizeDate = [newAuthorizeDate copy];
    [self removeObjectForKey:kDBCredentialAccessTokenKey];
    [self removeObjectForKey:kDBCredentialRefreshTokenKey];
    [self removeObjectForKey:kDBCredentialUserIdKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kDBCredentialExpireInKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kDBCredentialAuthorizeDateKey];
    if (_accessToken) {
        [self setString: _accessToken forKey:kDBCredentialAccessTokenKey];
        [self setString: _refreshToken forKey:kDBCredentialRefreshTokenKey];
        [self setString: _userId forKey:kDBCredentialUserIdKey];
        [[NSUserDefaults standardUserDefaults] setObject:_expireIn forKey:kDBCredentialExpireInKey];
        [[NSUserDefaults standardUserDefaults] setObject:_authorizeDate forKey:kDBCredentialAuthorizeDateKey];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Credential:\n\taccessToken: %@\n\trefreshToken: %@\n\tuserId: %@", _accessToken, _refreshToken, _userId];
}

@end

@implementation DBCredential (KeyChain)

- (NSString *)serviceName
{
    return [[NSBundle mainBundle] bundleIdentifier];
}

- (NSMutableDictionary *)keychainQuery:(NSString *)identifier
{
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (__bridge id)kSecClassGenericPassword, (__bridge id)kSecClass,
            [self serviceName], (__bridge id)kSecAttrService,
            identifier, (__bridge id)kSecAttrAccount,
            nil];;
}

- (NSString *)stringForKey:(NSString *)key {
    OSStatus osstatus;
    NSMutableDictionary * query = [self keychainQuery:key];
    [query setObject:(id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    
    CFDataRef stringData = NULL;
    osstatus = SecItemCopyMatching((__bridge CFDictionaryRef)query, (CFTypeRef*)&stringData);
    
    if(osstatus) return nil;
    
    NSString *string = [[NSString alloc] initWithData:(__bridge id)stringData
                                              encoding:NSUTF8StringEncoding];
    CFRelease(stringData);
	return string;
}

- (void)setString:(NSString *)string forKey:(NSString *)key {
    if (!string) {
        [self removeObjectForKey:key];
    }
    NSData *stringData = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary * query = [self keychainQuery:key];
    
    if ([self stringForKey:key]) {
        NSDictionary *update = [NSDictionary dictionaryWithObject:stringData forKey:(__bridge id)kSecValueData];
        SecItemUpdate((__bridge CFDictionaryRef)query, (__bridge CFDictionaryRef)update);
    } else {
        [query setObject:stringData forKey:(__bridge id)kSecValueData];
        SecItemAdd((__bridge CFDictionaryRef)query, NULL);
    }
}

- (void)removeObjectForKey:(NSString *)key
{
    NSMutableDictionary * query = [self keychainQuery:key];
    SecItemDelete((__bridge CFDictionaryRef)query);
}

@end
