//
//  SideBarTableViewController.h
//  Orb
//
//  Created by everbird on 10/30/12.
//  Copyright (c) 2012 everbird. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SideBarTableViewController : UITableViewController <UITableViewDelegate> {
    NSArray* _menuItems;
}
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentSizeLabel;

@end
