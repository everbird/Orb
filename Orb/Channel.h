//
//  Channel.h
//  Orb
//
//  Created by everbird on 1/24/13.
//  Copyright (c) 2013 everbird. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Program;

@interface Channel : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * priority;
@property (nonatomic, retain) NSSet *programs;
@end

@interface Channel (CoreDataGeneratedAccessors)

- (void)addProgramsObject:(Program *)value;
- (void)removeProgramsObject:(Program *)value;
- (void)addPrograms:(NSSet *)values;
- (void)removePrograms:(NSSet *)values;

@end
