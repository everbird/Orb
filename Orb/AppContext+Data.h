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

@interface AppContext (Data) <RKObjectLoaderDelegate>

@property (nonatomic, strong) NSArray* allPrograms;
@property (nonatomic, strong) NSArray* allChannels;

- (NSArray*)loadTodayProgramsFromLocal;
- (NSArray*)loadData:(Class)class FromLocalWithBlock:(ZZFetchRequestBlock)block;

- (void)fetchAllDataFromRemote;
- (void)fetchAllChannelsFromRemote;
- (void)fetchTodayDataFromRemoteByChannel:(Channel*)channel;
- (void)fetchTodayDataFromRemoteByChannel:(Channel*)channel WithDelegate:(id)delegate;

- (void)fetchCurrentProgramsFromRemote;
- (void)fetchProgramsFromRemoteByDate:(NSDate*)date;
- (void)fetchProgramsFromRemoteByDate:(NSDate*)date WithDelegate:(id)delegate;

- (id)loadObject:(Class)class ById:(NSInteger)objId;
- (Channel*)loadChannelById:(NSInteger)channelId;
- (Program*)loadProgramById:(NSInteger)programId;

@end
