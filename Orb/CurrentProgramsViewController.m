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
    
    [self loadObjectsFromLocal];
    
    if (self.savedSearchTerm) {
        [self.searchDisplayController setActive:self.searchWasActive];
        [self.searchDisplayController.searchBar setSelectedScopeButtonIndex:self.savedScopeButtonIndex];
        [self.searchDisplayController.searchBar setText:self.savedSearchTerm];
        self.savedSearchTerm = nil;
    }
    
    [self.tableView reloadData];
    self.tableView.scrollEnabled = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(remoteDataReloaded:) name:N_RELOADED_DATA_REMOTE object:nil];

    _filteredPrograms = [[NSMutableArray alloc] init];
    [appContext fetchCurrentProgramsFromRemote];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    _programs = nil;
    _filteredPrograms = nil;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // save the state of the search UI so that it can be restored if the view is re-created
    self.searchWasActive = [self.searchDisplayController isActive];
    self.savedSearchTerm = [self.searchDisplayController.searchBar text];
    self.savedScopeButtonIndex = [self.searchDisplayController.searchBar selectedScopeButtonIndex];
    
    [appContext.requestQueue cancelAllRequests];
}

- (void)loadObjectsFromLocal
{
    NSFetchRequest *request = [Program fetchRequest];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"id" ascending:YES];
    [request setSortDescriptors:[NSArray arrayWithObject:descriptor]];
    NSDate* now = [NSDate date];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"startDate <= %@ AND endDate >= %@", now, now];
    [request setPredicate:predicate];
    _programs = [Program objectsWithFetchRequest:request];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        return [_filteredPrograms count];
    }
	else
	{
        return [_programs count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Program* program = nil;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        program = [_filteredPrograms objectAtIndex:indexPath.row];
    } else {
        program = [_programs objectAtIndex:indexPath.row];
    }
    return [self makeCell:program ForTable:tableView];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ProgramCell* cell = (ProgramCell*)sender;
    DetailViewController* destination = [segue destinationViewController];
    destination.program = cell.program;
}

#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    NSString* searchText = [self.searchDisplayController.searchBar text];
    NSString* scope = [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption];
    [self filterContentForSearchText:searchText scope:scope];
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    NSString* scope = [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]];
    [self filterContentForSearchText:searchString scope:scope];
    
    return YES;
}

#pragma mark -
#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
	[_filteredPrograms removeAllObjects]; // First clear the filtered array.
	
    NSArray* programs = nil;
    if ([scope isEqualToString:@"All"]) {
        programs = appContext.allPrograms;
    } else if ([scope isEqualToString:@"Current"]) {
        programs = _programs;
    }
	for (Program *program in programs)
	{
        NSRange range = [program.name rangeOfString:searchText];
        if (range.location != NSNotFound) {
            [_filteredPrograms addObject:program];
        }
	}
}

- (void)remoteDataReloaded:(NSNotification*) notification
{
    [self loadObjectsFromLocal];
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark Private

- (ProgramCell*)makeCell:(Program*)program ForTable:(UITableView*)tableView
{
    NSString *reuseIdentifier = @"ProgramCell";
    ProgramCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[ProgramCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:DATE_FORMAT];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:TIMEZONE]];
    NSString* dateString = [formatter stringFromDate:program.startDate];
    cell.textLabel.text = program.name;
    cell.detailTextLabel.text = dateString;
    cell.program = program;
    return cell;
}

@end
