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
#import <CoreData+MagicalRecord.h>

#import "AppCommon.h"
#import "Program.h"
#import "DetailViewController.h"
#import "ProgramCell.h"

@interface ProgramListTableViewController () <NSFetchedResultsControllerDelegate>

@end

@implementation ProgramListTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _filteredPrograms = [[NSMutableArray alloc] init];
    [self fetchProgramsData];
    
    _sections = @[
        @"正在播出",
        @"即将播出",
        @"已播放完",
    ];
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
    NSFetchRequest *request = [Program MR_createFetchRequest];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"startDate" ascending:YES];
    request.sortDescriptors = @[descriptor];
    if (_channel) {
        NSDate* today = [[NSDate date] dateAtStartOfDay];
        
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"channelId == %d AND startDate >= %@", [_channel.id intValue], today];
        [request setPredicate:predicate];
    }
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

#pragma mark UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_sections count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [_sections objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray* programs = nil;
    if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        programs = _filteredPrograms;
    }
	else
	{
        programs = _programs;
    }
    NSArray* sectionPrograms = [self getProgramsFrom:programs BySectionIndex:section];
    return [sectionPrograms count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray* programs = nil;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        programs = _filteredPrograms;
    } else {
        programs = _programs;
    }
    Program* program = [self getProgramFrom:programs ByIndexPath:indexPath];
    return [self makeCell:program ForTable:tableView];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        Program* program = [self getProgramFrom:_filteredPrograms ByIndexPath:indexPath];
        ProgramCell* cell = [self makeCell:program ForTable:tableView];
        [self performSegueWithIdentifier:@"ProgramListToDetail" sender:cell];
    }
}

#pragma mark NSFetchedResultsControllerDelegate methods

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView reloadData];
}

@end
