//
//  ChartProgram.m
//  Orb
//
//  Created by everbird on 1/26/13.
//  Copyright (c) 2013 everbird. All rights reserved.
//

#import "ChartProgram.h"

#import "AppCommon.h"

@implementation ChartProgram

+ (ChartProgram*)parseFromDictionary:(NSDictionary*)dictionary
{
    ChartProgram* cp = [[ChartProgram alloc] init];
    cp.id = [dictionary objectForKey:@"id"];
    cp.pid = [dictionary objectForKey:@"pid"];
    cp.name = [dictionary objectForKey:@"name"];
    cp.datenum = [dictionary objectForKey:@"datenum"];
    cp.channelId = [dictionary objectForKey:@"channel_id"];
    cp.length = [dictionary objectForKey:@"length"];
    NSDateFormatter* f = [[NSDateFormatter alloc] init];
    // TODO: Deal with the timezone part parseing.
    [f setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss+08:00"];
    cp.startDtString = [dictionary objectForKey:@"start_dt"];
    cp.endDtString = [dictionary objectForKey:@"end_dt"];
    cp.updateDtString = [dictionary objectForKey:@"update_dt"];
    cp.startDt = [f dateFromString:cp.startDtString];
    cp.endDt = [f dateFromString:cp.endDtString];
    cp.updateDt = [f dateFromString:cp.updateDtString];
    return cp;
}


@end
