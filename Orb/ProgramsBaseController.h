//
//  ProgramsBaseController.h
//  Orb
//
//  Created by everbird on 11/17/12.
//  Copyright (c) 2012 everbird. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <RestKit/RestKit.h>
#import "Program.h"
#import "ProgramCell.h"

@interface ProgramsBaseController : UITableViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate> {
    NSArray* _programs;
    NSMutableArray* _filteredPrograms;
}

@property (strong, nonatomic) IBOutlet UITableView* tv;

@property (nonatomic, copy) NSString* savedSearchTerm;
@property (nonatomic) NSInteger savedScopeButtonIndex;
@property (nonatomic) BOOL searchWasActive;

- (void)loadObjectsFromLocal;
- (ProgramCell*)makeCell:(Program*)program ForTable:(UITableView*)tableView;

@end
