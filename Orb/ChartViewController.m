//
//  ChartViewController.m
//  Orb
//
//  Created by everbird on 1/26/13.
//  Copyright (c) 2013 everbird. All rights reserved.
//

#import "ChartViewController.h"

#import <AFNetworking/AFNetworking.h>

#import "AppCommon.h"
#import "ChartProgram.h"
#import "ChartProgramCell.h"
#import "DetailViewController.h"


@interface ChartViewController ()

@end

@implementation ChartViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSString* urlString = [SEER_API_BASE_URL stringByAppendingString:SEER_API_CHART];
    NSURLRequest* request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    AFJSONRequestOperation* operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSDictionary* r = JSON;
        _top250Programs = [r objectForKey:@"top250"];
        _highRatingPrograms = [r objectForKey:@"rating"];
        _sections = @[_top250Programs, _highRatingPrograms];
        [self.tableView reloadData];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        //
        NSLog(@"error: %@", error);
    }];
    
    [operation start];
    
    _top250Programs = nil;
    _highRatingPrograms = nil;
    _sections = nil;
    _sectionTitles = @[@"top250", @"rating"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray* programs = [_sections objectAtIndex:section];
    return [programs count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [_sectionTitles objectAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChartProgramCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChartCell"];
    
    NSArray* programs = [_sections objectAtIndex:indexPath.section];
    NSDictionary* chartProgramInfo = [programs objectAtIndex:indexPath.row];
    ChartProgram* cp = [ChartProgram parseFromDictionary:chartProgramInfo];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:DATE_FORMAT];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:TIMEZONE]];
    NSString* dateString = [formatter stringFromDate:cp.startDt];
    cell.textLabel.text = cp.name;
    cell.detailTextLabel.text = dateString;
    cell.chartProgram = cp;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ChartProgramCell* cell = (ChartProgramCell*)sender;
    DetailViewController* destination = [segue destinationViewController];
    ChartProgram* cp = cell.chartProgram;
    Program* p = [appContext loadObject:[Program class] ByPid:cp.pid];
//    Program* p = [appContext loadObject:[Program class] ById:[cp.id intValue]];
    destination.program = p;
}

@end
