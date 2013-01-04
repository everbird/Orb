//
//  CurrentProgramsViewController.m
//  Orb
//
//  Created by everbird on 11/13/12.
//  Copyright (c) 2012 everbird. All rights reserved.
//

#import "CurrentProgramsViewController.h"

#import "AppCommon.h"
#import "Program.h"
#import "DetailViewController.h"
#import "ProgramCell.h"

@interface CurrentProgramsViewController ()

@end

@implementation CurrentProgramsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _filteredPrograms = [[NSMutableArray alloc] init];
    [appContext fetchCurrentProgramsFromRemote];
}

- (void)loadObjectsFromLocal
{
    NSFetchRequest *request = [Program fetchRequest];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"channel.priority" ascending:NO];
    [request setSortDescriptors:[NSArray arrayWithObject:descriptor]];
    NSDate* now = [NSDate date];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"startDate <= %@ AND endDate >= %@", now, now];
    [request setPredicate:predicate];
    _programs = [Program objectsWithFetchRequest:request];
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        Program* program = [self getProgramFrom:_filteredPrograms ByIndexPath:indexPath];
        ProgramCell* cell = [self makeCell:program ForTable:tableView];
        [self performSegueWithIdentifier:@"CurrentListToDetail" sender:cell];
    }
}

@end
