//
//  RevealRootController.m
//  Orb
//
//  Created by everbird on 10/30/12.
//  Copyright (c) 2012 everbird. All rights reserved.
//

#import "RevealRootController.h"

@interface RevealRootController ()

@end

@implementation RevealRootController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])) {
        self.shouldDelegateAutorotateToVisiblePanel = NO;
        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        self.leftPanel = [storyboard instantiateViewControllerWithIdentifier:@"left"];
        self.centerPanel = [storyboard instantiateViewControllerWithIdentifier:@"center"];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
