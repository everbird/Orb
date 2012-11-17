//
//  DetailViewController.h
//  Orb
//
//  Created by everbird on 10/21/12.
//  Copyright (c) 2012 everbird. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Program.h"
#import "Channel.h"

@interface DetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *tmpLabel;
@property (weak, nonatomic) Program* program;
@property (weak, nonatomic) IBOutlet UILabel *lengthLabel;
@property (weak, nonatomic) IBOutlet UILabel *channelLabel;
@property (weak, nonatomic) IBOutlet UILabel *startDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *endDateLabel;
@property (weak, nonatomic) IBOutlet UIButton *booking;

- (IBAction)booking:(id)sender;

@end
