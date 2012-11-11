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
	// Do any additional setup after loading the view, typically from a nib.
    
    if (self.savedSearchTerm) {
        [self.searchDisplayController setActive:self.searchWasActive];
        [self.searchDisplayController.searchBar setSelectedScopeButtonIndex:self.savedScopeButtonIndex];
        [self.searchDisplayController.searchBar setText:self.savedSearchTerm];
        self.savedSearchTerm = nil;
    }
    
    [self.tableView reloadData];
    self.tableView.scrollEnabled = YES;
    
    _filteredPrograms = [NSMutableArray arrayWithCapacity:[_programs count]];
    [self loadProgramsData];
}

- (void)loadView
{
    [super loadView];

    _channel = [appContext loadChannelById:3];
    // Load statuses from core data
    [self loadObjectsFromLocal];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
    [self setView:nil];
    _programs = nil;
    _channel = nil;
    _filteredPrograms = nil;
}

- (void)viewDidDisappear:(BOOL)animated
{
    // save the state of the search UI so that it can be restored if the view is re-created
    self.searchWasActive = [self.searchDisplayController isActive];
    self.savedSearchTerm = [self.searchDisplayController.searchBar text];
    self.savedScopeButtonIndex = [self.searchDisplayController.searchBar selectedScopeButtonIndex];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)loadAllProgramsData
{
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    [objectManager loadObjectsAtResourcePath:@"/api/program" delegate:self];
    
}

- (void)loadProgramsData
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
    NSLog(@">>>%@", _programs);
}

#pragma mark RKObjectLoaderDelegate methods

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"LastUpdatedAt"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"Loaded statuses: %@", objects);
    [self loadObjectsFromLocal];
    [_tv reloadData];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                     message:[error localizedDescription]
                                                    delegate:nil
                                           cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    NSLog(@"Hit error: %@", error);
}


#pragma mark UITableViewDataSource methods

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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDate *lastUpdatedAt = [[NSUserDefaults standardUserDefaults] objectForKey:@"LastUpdatedAt"];
    NSString *dateString = [NSDateFormatter localizedStringFromDate:lastUpdatedAt dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterMediumStyle];
    if (nil == dateString) {
        dateString = @"Never";
    }
    return [NSString stringWithFormat:@"Last Load: %@", dateString];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        Program* program = [_filteredPrograms objectAtIndex:indexPath.row];
        ProgramCell* cell = [self makeCell:program ForTable:tableView];
        [self performSegueWithIdentifier:@"ProgramListToDetail" sender:cell];
    }
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
