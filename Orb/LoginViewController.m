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
        
        NSDictionary* data = @{
            @"douban_id": appContext.credential.userId,
            @"name": @"<testting>",
            @"access_token": appContext.credential.accessToken,
        };
        [appContext.client postPath:SEER_API_USER
                         parameters:data
                            success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            //
        }];
        
        [self dismissViewControllerAnimated:YES completion:^{
            NSLog(@">>> dismiss: %@", self);
        }];
    } failed:^(NSError* error){
        NSLog(@"login failed with error: %@", error);
    }];
    
}
@end
