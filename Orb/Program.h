//
//  Program.h
//  Orb
//
//  Created by everbird on 10/21/12.
//  Copyright (c) 2012 everbird. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Program : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * length;
@property (nonatomic, retain) NSNumber * channelId;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSNumber * datenum;
@property (nonatomic, retain) NSDate * updateDate;
@property (nonatomic, retain) NSManagedObject *channel;

@end
