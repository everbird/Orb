//
//  ViewController.m
//  Orb
//
//  Created by everbird on 10/20/12.
//  Copyright (c) 2012 everbird. All rights reserved.
//

#import "ProgramListTableViewController.h"
#import <RestKit/CoreData.h>
#import <JSONKit/JSONKit.h>
#import <NSDate-Extensions/NSDate-Utilities.h>

#import "AppCommon.h"
#import "Program.h"
#import "DetailViewController.h"
#import "ProgramCell.h"

@interface ProgramListTableViewController ()

@end

@implementation ProgramListTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _filteredPrograms = [[NSMutableArray alloc] init];
    [self fetchProgramsData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    _channel = nil;
}

- (void)fetchProgramsData
{
    if (_channel) {
        [appContext fetchTodayDataFromRemoteByChannel:_channel];
    } else {
        [appContext fetchAllDataFromRemote];
    }
}

- (void)loadObjectsFromLocal
{
    NSFetchRequest *request = [Program fetchRequest];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"startDate" ascending:YES];
    [request setSortDescriptors:[NSArray arrayWithObject:descriptor]];
    if (_channel) {
        NSDate* today = [[NSDate date] dateAtStartOfDay];
        
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"channelId == %d AND startDate >= %@", [_channel.id intValue], today];
        [request setPredicate:predicate];
    }
    _programs = [Program objectsWithFetchRequest:request];
}

#pragma mark UITableViewDataSource methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        Program* program = [_filteredPrograms objectAtIndex:indexPath.row];
        ProgramCell* cell = [self makeCell:program ForTable:tableView];
        [self performSegueWithIdentifier:@"ProgramListToDetail" sender:cell];
    }
}

@end
