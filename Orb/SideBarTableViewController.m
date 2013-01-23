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
#import "DownloadManager.h"

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
    
    NSInteger packageCount = 8;
    if ([category isEqualToString:@"sync"]) {
        category = @"channels";
        NSDateFormatter* f = [[NSDateFormatter alloc] init];
        [f setDateFormat:@"yyyyMMdd"];
        for (int i=0; i<packageCount; i++) {
            NSDate* day = [[NSDate date] dateByAddingTimeInterval:60*60*24*i];
            NSString* datenum = [f stringFromDate:day];
            [DownloadManager downloadByDatenumber:datenum WithBlock:^(NSInteger bytesRead, long long totalBytesRead, long long totalBytesExpected, long long totalBytesReadForFile, long long totalBytesExpectedToReadForFile) {
                float percentDone = totalBytesReadForFile/(float)totalBytesExpectedToReadForFile;
                
                self.progressView.progress = percentDone;
                self.progressLabel.text = [NSString stringWithFormat:@"%.0f%%",percentDone*100];
                
                self.currentSizeLabel.text = [NSString stringWithFormat:@"[%d/%d]|(%lli/%lli) K", i+1, packageCount, totalBytesReadForFile/1024, totalBytesExpectedToReadForFile/1024];
                
                NSLog(@"------%f",percentDone);
                NSLog(@"Operation%i: bytesRead: %d", 1, bytesRead);
                NSLog(@"Operation%i: totalBytesRead: %lld", 1, totalBytesRead);
                NSLog(@"Operation%i: totalBytesExpected: %lld", 1, totalBytesExpected);
                NSLog(@"Operation%i: totalBytesReadForFile: %lld", 1, totalBytesReadForFile);
                NSLog(@"Operation%i: totalBytesExpectedToReadForFile: %lld", 1, totalBytesExpectedToReadForFile);
            }];
        }
        
        return;
    }

    RevealRootController* vc = (RevealRootController*)appContext.rootVC;
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    vc.centerPanel = [storyboard instantiateViewControllerWithIdentifier:category];
}

- (void)viewDidUnload {
    [self setProgressView:nil];
    [self setProgressLabel:nil];
    [self setCurrentSizeLabel:nil];
    [super viewDidUnload];
}
@end
