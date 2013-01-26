//
//  AppContext+Data.h
//  Orb
//
//  Created by everbird on 11/9/12.
//  Copyright (c) 2012 everbird. All rights reserved.
//

#import "AppContext.h"

#import "AppDefines.h"
#import <RestKit/RestKit.h>
#import <objc/runtime.h>
#import "Channel.h"

@interface AppContext (Data)

@property (nonatomic, strong) NSArray* allPrograms;
@property (nonatomic, strong) NSArray* allChannels;

- (NSArray*)loadTodayProgramsFromLocal;
- (NSArray*)loadData:(Class)class FromLocalWithBlock:(ZZFetchRequestBlock)block;

- (void)fetchAllDataFromRemote;
- (void)syncAllDataFromRemote;
- (void)fetchAllChannelsFromRemote;
- (void)fetchTodayDataFromRemoteByChannel:(Channel*)channel;

- (void)fetchCurrentProgramsFromRemote;
- (void)fetchProgramsFromRemoteByDate:(NSDate*)date;

- (id)loadObject:(Class)class ById:(NSInteger)objId;
- (id)loadObject:(Class)class ByPid:(NSString*)pid;
- (Channel*)loadChannelById:(NSInteger)channelId;
- (Program*)loadProgramById:(NSInteger)programId;

- (NSArray*)loadAllProgramsByDatenum:(NSString*)datenum;
- (NSArray*)loadAllProgramsByDatenum:(NSString*)datenum byChannel:(Channel*)channel;
- (void)deleteByDatenum:(NSString*)datenum onlyExpired:(BOOL)onlyExpired;
- (void)deleteByDatenum:(NSString*)datenum byChannel:(Channel*)channel onlyExpired:(BOOL)onlyExpired;

@end
