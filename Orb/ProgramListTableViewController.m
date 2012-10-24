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

#import "Program.h"
#import "DetailViewController.h"
#import "ProgramCell.h"

@interface ProgramListTableViewController ()

@end

@implementation ProgramListTableViewController

@synthesize tv = _tv;
@synthesize criteria = _criteria;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self loadProgramsData];
}

- (void)loadView
{
    [super loadView];

    // Load statuses from core data
    [self loadObjectsFromDataStore];
}

- (void)viewDidUnload
{
    [self setView:nil];
    [self setCriteria:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)loadProgramsData
{
    NSNumberFormatter* formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber* channel_id = [formatter numberFromString:_criteria];
    
    NSLog(@">>> channel: %@", channel_id);

    NSDictionary* queryDict = @{ @"filters": @[
                                        @{
                                        @"name": @"channel_id",
                                        @"op": @"==",
                                        @"val": channel_id
                                        }
                                    ]
                                };
    NSString* query = [queryDict JSONString];
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    [objectManager loadObjectsAtResourcePath:[@"/api/program" stringByAppendingQueryParameters:@{@"q": query}] delegate:self];
}

- (void)loadObjectsFromDataStore
{
    NSFetchRequest *request = [Program fetchRequest];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"id" ascending:YES];
    [request setSortDescriptors:[NSArray arrayWithObject:descriptor]];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"channelId == %@", _criteria];
    [request setPredicate:predicate];
    _programs = [Program objectsWithFetchRequest:request];
    NSLog(@">>>%@", _programs);
}

#pragma mark RKObjectLoaderDelegate methods

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"LastUpdatedAt"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"Loaded statuses: %@", objects);
    [self loadObjectsFromDataStore];
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

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    return [_programs count];
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
    NSString *reuseIdentifier = @"ProgramCell";
    ProgramCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    Program* program = [_programs objectAtIndex:indexPath.row];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    NSString* dateString = [formatter stringFromDate:program.startDate];
    cell.textLabel.text = program.name;
    cell.detailTextLabel.text = dateString;
    cell.program = program;
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ProgramCell* cell = (ProgramCell*)sender;
    DetailViewController* destination = [segue destinationViewController];
    destination.program = cell.program;
}

@end
