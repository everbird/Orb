//
//  LoginViewController.h
//  Orb
//
//  Created by everbird on 1/27/13.
//  Copyright (c) 2013 everbird. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *dismissButton;

- (IBAction)doDismiss:(id)sender;
- (IBAction)doLogin:(id)sender;

@end
