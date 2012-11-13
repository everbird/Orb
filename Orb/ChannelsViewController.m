//
//  ChannelsViewController.m
//  Orb
//
//  Created by everbird on 11/11/12.
//  Copyright (c) 2012 everbird. All rights reserved.
//

#import "ChannelsViewController.h"

#import "ChannelCell.h"
#import "AppCommon.h"
#import "ProgramListTableViewController.h"

@interface ChannelsViewController ()

@end

@implementation ChannelsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)loadView
{
    [super loadView];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [appContext.allChannels count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier = @"ChannelCell";
    ChannelCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[ChannelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    cell.channel = [appContext.allChannels objectAtIndex:indexPath.row];
    cell.textLabel.text = cell.channel.name;
    return cell;
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ChannelCell* cell = (ChannelCell*)sender;
    ProgramListTableViewController* destination = [segue destinationViewController];
    destination.channel = cell.channel;
}

@end
