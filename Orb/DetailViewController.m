//
//  DetailViewController.m
//  Orb
//
//  Created by everbird on 10/21/12.
//  Copyright (c) 2012 everbird. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController
@synthesize tmpLabel = _tmpLabel;
@synthesize program = _program;
@synthesize lengthLabel = _lengthLabel;
@synthesize channelLabel = _channelLabel;
@synthesize startDateLabel = _startDateLabel;
@synthesize booking = _booking;

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
    [self setTmpLabel:nil];
    [self setLengthLabel:nil];
    [self setChannelLabel:nil];
    [self setStartDateLabel:nil];
    [self setBooking:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)loadView
{
    [super loadView];

    _tmpLabel.text = _program.name;
    _lengthLabel.text = [_program.length stringValue];
    Channel* channel = (Channel*)_program.channel;
    _channelLabel.text = [channel name];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    NSString* dateString = [formatter stringFromDate:_program.startDate];
    _startDateLabel.text = dateString;
}

- (IBAction)booking:(id)sender
{
//    NSDate* now = [NSDate new];
//    if (now > _program.startDate) {
//        NSLog(@"已开播或播完");
//        return;
//    }

    NSLog(@"booking: %@", _program);
    UILocalNotification *notification=[[UILocalNotification alloc] init];
    if (notification!=nil) {
        Channel* channel = (Channel*)_program.channel;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm"];
        [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
        NSString* dateString = [formatter stringFromDate:_program.startDate];
        notification.fireDate=_program.startDate;
//        notification.fireDate=[now dateByAddingTimeInterval:10];
        notification.timeZone=[NSTimeZone timeZoneWithAbbreviation:@"GMT"];
        notification.alertBody=[NSString stringWithFormat:@"%@ %@ 即将开播: %@", [channel name], dateString, _program.name];
        notification.soundName=@"dingdang.caf";
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}

@end
