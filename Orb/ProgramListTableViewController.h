//
//  ViewController.h
//  Orb
//
//  Created by everbird on 10/20/12.
//  Copyright (c) 2012 everbird. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>

@interface ProgramListTableViewController : UITableViewController <RKObjectLoaderDelegate, UITableViewDelegate, UITableViewDataSource> {
    NSArray* _programs;
}

@property (strong, nonatomic) NSString* criteria;
@property (strong, nonatomic) IBOutlet UITableView* tv;

- (void)loadObjectsFromDataStore;

@end
