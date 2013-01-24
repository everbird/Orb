//
//  Program.h
//  Orb
//
//  Created by everbird on 1/24/13.
//  Copyright (c) 2013 everbird. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Channel;

@interface Program : NSManagedObject

@property (nonatomic, retain) NSNumber * channelId;
@property (nonatomic, retain) NSNumber * datenum;
@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSNumber * length;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * pid;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSDate * updateDate;
@property (nonatomic, retain) Channel *channel;

@end
