//
//  AppContext+Authorize.m
//  Orb
//
//  Created by everbird on 1/27/13.
//  Copyright (c) 2013 everbird. All rights reserved.
//

#import "AppContext+Authorize.h"

#import <JSONKit/JSONKit.h>
#import <RestKit/RestKit.h>

#import "LocalConfig.h"
#import "NSDictionary+Orb.h"

@implementation AppContext (Authorize)

- (void)loginWithUsername:(NSString*)username
                 password:(NSString*)password
                  success:(ZZFinishedBlock)success
                   failed:(ZZFailedBlock)failed
{
    
    NSDictionary* query = @{
    @"client_id": ORB_API_APIKEY,
    @"client_secret": ORB_API_SECRET,
    @"redirect_uri": ORB_API_CALLBACK,
    @"grant_type": @"password",
    @"username": username,
    @"password": password,
    };
    [self authorizeWithQuery:query
                     success:success
                      failed:failed];
}

- (void)logoutWithBlock:(ZZRunBlock)completion
{
    NSLog(@"in logout");
    [self.credential invalidate];
    completion();
}

- (void)refreshTokenOnSuccess:(ZZFinishedBlock)success
                       failed:(ZZFailedBlock)failed
{
    NSDictionary* query = @{
    @"client_id": ORB_API_APIKEY,
    @"client_secret": ORB_API_SECRET,
    @"redirect_uri": ORB_API_CALLBACK,
    @"grant_type": @"refresh_token",
    @"refresh_token": self.credential.refreshToken,
    };
    [self authorizeWithQuery:query
                     success:success
                      failed:failed];
}

#pragma mark - Private


- (void)authorizeWithQuery:(NSDictionary*)query
                   success:(ZZFinishedBlock)success
                    failed:(ZZFailedBlock)failed
{
    NSString* urlString = @"https://www.douban.com/service/auth2/token";
    NSString* queryString = [query urlEncodedString];
    NSMutableURLRequest* request = [NSMutableURLRequest new];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSLog(@">>> urlString:%@", urlString);
    NSURL* url = [NSURL URLWithString:urlString];
    request.URL = url;
    request.HTTPMethod = @"POST";
    NSData* postData = [queryString dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:postData];
    [request setValue:[NSString stringWithFormat:@"%d", postData.length] forHTTPHeaderField:@"Content-Length"];
    
    NSHTTPURLResponse* resp;
    NSError* error = nil;
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&resp error:&error];
    if (error) {
        failed(error);
    } else {
        NSDictionary* results = [data objectFromJSONData];
        NSLog(@">>>results:%@", results);
        NSString* token = [results objectForKey:@"access_token"];
        
        if (token) {
            NSString* userId = [results objectForKey:@"douban_user_id"];
            NSString* refreshToken = [results objectForKey:@"refresh_token"];
            NSNumber* expireIn = [results objectForKey:@"expires_in"];
            NSLog(@">>>token:%@", token);
            [self.credential updateAccessToken:token
                                  refreshToken:refreshToken
                                      expireIn:expireIn
                                 authorizeDate:[NSDate new]
                                        userId:userId];
        } else {
            NSLog(@">>> no token");
        }
        success();
    }
}

@end
