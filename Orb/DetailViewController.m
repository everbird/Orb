//
//  DetailViewController.m
//  Orb
//
//  Created by everbird on 10/21/12.
//  Copyright (c) 2012 everbird. All rights reserved.
//

#import "DetailViewController.h"

#import "AppCommon.h"

@interface DetailViewController ()

@end

@implementation DetailViewController
@synthesize tmpLabel = _tmpLabel;
@synthesize program = _program;
@synthesize lengthLabel = _lengthLabel;
@synthesize channelLabel = _channelLabel;
@synthesize startDateLabel = _startDateLabel;
@synthesize booking = _booking;


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
    [self setEndDateLabel:nil];
    [self setUpdateDateLabel:nil];
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
    [formatter setDateFormat:DATE_FORMAT];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:TIMEZONE]];
    NSString* startDateString = [formatter stringFromDate:_program.startDate];
    NSString* endDateString = [formatter stringFromDate:_program.endDate];
    NSString* updateDateString = [formatter stringFromDate:_program.updateDate];
    _startDateLabel.text = startDateString;
    _endDateLabel.text = endDateString;
    _updateDateLabel.text = updateDateString;
}

- (IBAction)booking:(id)sender
{
    NSLog(@"booking: %@", _program);
    UILocalNotification *notification=[[UILocalNotification alloc] init];
    if (notification!=nil) {
        Channel* channel = (Channel*)_program.channel;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm"];
        [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:TIMEZONE]];
        NSString* dateString = [formatter stringFromDate:_program.startDate];
        NSDate* now = [NSDate new];
        NSTimeInterval ti = _program.startDate.timeIntervalSince1970 - now.timeIntervalSince1970;
        NSLog(@"sec: %f", ti);
        notification.fireDate=[now dateByAddingTimeInterval:ti];
        notification.timeZone = [NSTimeZone timeZoneWithAbbreviation:TIMEZONE];
        notification.alertBody=[NSString stringWithFormat:@"%@ %@ 即将开播: %@", [channel name], dateString, _program.name];
        notification.soundName=@"dingdang.caf";
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}

@end
