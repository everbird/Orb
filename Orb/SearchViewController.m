//
//  SearchViewController.m
//  Orb
//
//  Created by everbird on 10/22/12.
//  Copyright (c) 2012 everbird. All rights reserved.
//

#import "SearchViewController.h"

#import "ProgramListTableViewController.h"

@interface SearchViewController ()

@end

@implementation SearchViewController
@synthesize criteria = _criteria;
@synthesize searchButton = _searchButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setCriteria:nil];
    [self setSearchButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    SearchViewController* source = [segue sourceViewController];
    NSString* criteriaText = [source criteria].text;
    ProgramListTableViewController* destination = [segue destinationViewController];
    destination.criteria = criteriaText;
}

@end
