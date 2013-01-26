//
//  ChartProgram.h
//  Orb
//
//  Created by everbird on 1/26/13.
//  Copyright (c) 2013 everbird. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChartProgram : NSObject

@property (nonatomic, copy) NSNumber* id;
@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* pid;
@property (nonatomic, copy) NSNumber* length;
@property (nonatomic, copy) NSNumber* datenum;
@property (nonatomic, copy) NSNumber* channelId;
@property (nonatomic, copy) NSDate* startDt;
@property (nonatomic, copy) NSDate* endDt;
@property (nonatomic, copy) NSDate* updateDt;
@property (nonatomic, copy) NSString* startDtString;
@property (nonatomic, copy) NSString* endDtString;
@property (nonatomic, copy) NSString* updateDtString;

+ (ChartProgram*)parseFromDictionary:(NSDictionary*)dictionary;

@end
