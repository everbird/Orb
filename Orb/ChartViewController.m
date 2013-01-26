//
//  ChartViewController.m
//  Orb
//
//  Created by everbird on 1/26/13.
//  Copyright (c) 2013 everbird. All rights reserved.
//

#import "ChartViewController.h"

@interface ChartViewController ()

@end

@implementation ChartViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    _top250Programs = @[@"123", @"456"];
    _highRatingPrograms = @[@"apple", @"orange"];
    _sections = @[_top250Programs, _highRatingPrograms];
    _sectionTitles = @[@"A", @"B"];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChartCell" forIndexPath:indexPath];
    
    NSArray* programs = [_sections objectAtIndex:indexPath.section];
    NSString* tmp = [programs objectAtIndex:indexPath.row];
    cell.textLabel.text = tmp;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

@end
