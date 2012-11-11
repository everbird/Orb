//
//  ViewController.h
//  Orb
//
//  Created by everbird on 10/20/12.
//  Copyright (c) 2012 everbird. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <RestKit/RestKit.h>
#import "Channel.h"

@interface ProgramListTableViewController : UITableViewController <RKObjectLoaderDelegate, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate> {
    NSArray* _programs;
    NSMutableArray* _filteredPrograms;
}

@property (strong, nonatomic) Channel* channel;
@property (strong, nonatomic) IBOutlet UITableView* tv;

@property (nonatomic, copy) NSString* savedSearchTerm;
@property (nonatomic) NSInteger savedScopeButtonIndex;
@property (nonatomic) BOOL searchWasActive;

- (void)loadObjectsFromLocal;

@end
