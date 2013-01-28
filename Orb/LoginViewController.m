//
//  LoginViewController.m
//  Orb
//
//  Created by everbird on 1/27/13.
//  Copyright (c) 2013 everbird. All rights reserved.
//

#import "LoginViewController.h"

#import "AppCommon.h"
#import "AppContext+Authorize.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [self setEmailTextField:nil];
    [self setPasswordTextField:nil];
    [self setLoginButton:nil];
    [self setDismissButton:nil];
    [super viewDidUnload];
}

- (IBAction)doDismiss:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)doLogin:(id)sender {
    NSString* email = _emailTextField.text;
    NSString* password = _passwordTextField.text;
    [appContext loginWithUsername:email
                         password:password
    success:^(){
        appContext.client.parameterEncoding = AFJSONParameterEncoding;
        NSString* deviceToken = [[NSUserDefaults standardUserDefaults] valueForKey:DEVICE_TOKEN];
        
        NSDictionary* queryData = @{
            @"filters": @[
                @{ @"name": @"douban_id", @"op": @"==", @"val": appContext.credential.userId },
            ],
        };
        [appContext.client getPath:SEER_API_USER
                        parameters:queryData
                           success:^(AFHTTPRequestOperation *operation, id responseObject) {
                               //
                               NSDictionary* result = responseObject;
                               NSArray* objects = [result objectForKey:@"objects"];
                               BOOL isExist = [objects count] != 0;
                               if (isExist) {
                                   NSDictionary* userInfo = [objects objectAtIndex:0];
                                   NSArray* deviceInfos = [userInfo objectForKey:@"devices"];
                                   BOOL isTokenExist = NO;
                                   for (NSDictionary* deviceInfo in deviceInfos) {
                                       NSString* s = [deviceInfo objectForKey:@"device_token"];
                                       if ([deviceToken isEqualToString:s]) {
                                           isTokenExist = YES;
                                           break;
                                       }
                                   }
                                   if (!isTokenExist) {
                                       NSDictionary* deviceData = @{
                                           @"douban_id": appContext.credential.userId,
                                           @"device_token": deviceToken!=nil? deviceToken: @"<test token>",
                                           @"user_id": [userInfo objectForKey:@"id"],
                                       };
                                       [appContext.client postPath:SEER_API_USER_DEVICE parameters:deviceData success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                           //
                                           NSLog(@"token: %@ regiested", deviceToken);
                                       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                           //
                                           NSLog(@"error: %@", error);
                                       }];
                                   }
                               } else {
                                   NSDictionary* data = @{
                                        @"douban_id": appContext.credential.userId,
                                        @"name": @"<testting>",
                                        @"access_token": appContext.credential.accessToken,
                                        @"devices": @[
                                            @{
                                                @"douban_id": appContext.credential.userId,
                                                @"device_token": deviceToken!=nil? deviceToken: @"<test token>",
                                            },
                                        ],
                                    };
                                    [appContext.client postPath:SEER_API_USER
                                                     parameters:data
                                                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                        NSLog(@">>> responseObject: %@", responseObject);
                                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                        //
                                        NSLog(@"error: %@", error);
                                    }];
                               }
                           } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                               //
                               NSLog(@">>> failed:%@", error);
                           }];
        
        
        [self dismissViewControllerAnimated:YES completion:^{
            NSLog(@">>> dismiss: %@", self);
        }];
    } failed:^(NSError* error){
        NSLog(@"login failed with error: %@", error);
    }];
    
}
@end
