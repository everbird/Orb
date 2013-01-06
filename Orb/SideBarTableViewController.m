//
//  SideBarTableViewController.m
//  Orb
//
//  Created by everbird on 10/30/12.
//  Copyright (c) 2012 everbird. All rights reserved.
//

#import "SideBarTableViewController.h"

#import "MenuCategoryCell.h"
#import "AppCommon.h"

#import "RevealRootController.h"

@interface SideBarTableViewController ()

@end

@implementation SideBarTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView
{
    [super loadView];
    
    _menuItems = @[
        @"current",
        @"channels",
        @"sync",
    ];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_menuItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier = @"MenuCell";

    MenuCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[MenuCategoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    cell.textLabel.text = [_menuItems objectAtIndex:indexPath.row];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Category";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* category = [_menuItems objectAtIndex:indexPath.row];
    NSLog(@"selected: %@", category);
    
    if ([category isEqualToString:@"sync"]) {
        category = @"channels";
//        [appContext fetchAllDataFromRemote];
        [appContext syncAllDataFromRemote];
    }

    RevealRootController* vc = (RevealRootController*)appContext.rootVC;
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    vc.centerPanel = [storyboard instantiateViewControllerWithIdentifier:category];
}

@end
