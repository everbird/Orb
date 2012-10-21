//
//  ViewController.m
//  Orb
//
//  Created by everbird on 10/20/12.
//  Copyright (c) 2012 everbird. All rights reserved.
//

#import "ViewController.h"
#import <RestKit/CoreData.h>
#import <JSONKit/JSONKit.h>

#import "Program.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize table = _table;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    UILocalNotification *notification=[[UILocalNotification alloc] init];
    if (notification!=nil) {
        NSLog(@">> support local notification");
        NSDate *now=[NSDate new];
        notification.fireDate=[now dateByAddingTimeInterval:10];
        notification.timeZone=[NSTimeZone defaultTimeZone];
        notification.alertBody=@"该去吃晚饭了！";
        notification.soundName=@"dingdang.caf";
        [[UIApplication sharedApplication]   scheduleLocalNotification:notification];
    }
    
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
    [self setTable:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)loadProgramsData
{
    NSDictionary* queryDict = @{ @"filters": @[
                                        @{
                                        @"name": @"channel_id",
                                        @"op": @"==",
                                        @"val": @1
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
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"startDate" ascending:NO];
    [request setSortDescriptors:[NSArray arrayWithObject:descriptor]];
    _programs = [Program objectsWithFetchRequest:request];
}

#pragma mark RKObjectLoaderDelegate methods

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"LastUpdatedAt"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"Loaded statuses: %@", objects);
    [self loadObjectsFromDataStore];
    [_table reloadData];
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

#pragma mark UITableViewDelegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = [[[_programs objectAtIndex:indexPath.row] name] sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(300, 9000)];
    return size.height + 10;
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
    NSString *reuseIdentifier = @"Program Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"listbg.png"]];
    }
    Program* program = [_programs objectAtIndex:indexPath.row];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    NSString* dateString = [formatter stringFromDate:program.startDate];
    NSString* show = [NSString stringWithFormat:@"[%@]%@", dateString, program.name];
    cell.textLabel.text = show;
    return cell;
}

@end
