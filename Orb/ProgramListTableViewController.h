//
//  ViewController.h
//  Orb
//
//  Created by everbird on 10/20/12.
//  Copyright (c) 2012 everbird. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <RestKit/RestKit.h>
#import "ProgramsBaseController.h"
#import "Channel.h"

@interface ProgramListTableViewController : ProgramsBaseController

@property (strong, nonatomic) Channel* channel;

@end
