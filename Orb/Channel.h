//
//  Channel.h
//  Orb
//
//  Created by everbird on 10/21/12.
//  Copyright (c) 2012 everbird. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Program;

@interface Channel : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) Program *programs;

@end
