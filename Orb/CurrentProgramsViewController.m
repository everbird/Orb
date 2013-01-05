//
//  CurrentProgramsViewController.m
//  Orb
//
//  Created by everbird on 11/13/12.
//  Copyright (c) 2012 everbird. All rights reserved.
//

#import "CurrentProgramsViewController.h"

#import <CoreData+MagicalRecord.h>
#import "AppCommon.h"
#import "Program.h"
#import "DetailViewController.h"
#import "ProgramCell.h"

@interface CurrentProgramsViewController () <NSFetchedResultsControllerDelegate>

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
    NSFetchRequest *request = [Program MR_createFetchRequest];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"channel.priority" ascending:NO];
    request.sortDescriptors = @[descriptor];
    NSDate* now = [NSDate date];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"startDate <= %@ AND endDate >= %@", now, now];
    [request setPredicate:predicate];
    
    NSFetchedResultsController* fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                                               managedObjectContext:[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext
                                                                                                 sectionNameKeyPath:nil
                                                                                                          cacheName:nil];
    fetchedResultsController.delegate = self;
    NSError *error = nil;
    BOOL fetchSuccessful = [fetchedResultsController performFetch:&error];
    
    if (fetchSuccessful) {
        _programs = fetchedResultsController.fetchedObjects;
    }
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
