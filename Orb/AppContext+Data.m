//
//  AppContext+Data.m
//  Orb
//
//  Created by everbird on 11/9/12.
//  Copyright (c) 2012 everbird. All rights reserved.
//

#import "AppContext+Data.h"

#import "Program.h"
#import "AppContext+RestKit.h"
#import "AppConsts.h"
#import <JSONKit/JSONKit.h>
#import <NSDate-Extensions/NSDate-Utilities.h>

@implementation AppContext (Data)

@dynamic allPrograms;
@dynamic allChannels;

NSString* const kAllPrograms = @"kAllPrograms";
NSString* const kAllChannels = @"kAllChannels";

- (NSArray*)allPrograms
{
    id objs = objc_getAssociatedObject(self, (__bridge const void *)(kAllPrograms));
    if (!objs) {
        objs = [self loadTodayProgramsFromLocal];
        [self setAllPrograms:objs];
    }
    return objs;
}

- (void)setAllPrograms:(NSArray *)allPrograms
{
    objc_setAssociatedObject(self, (__bridge const void *)(kAllPrograms), allPrograms, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSArray*)allChannels
{
    id objs = objc_getAssociatedObject(self, (__bridge const void *)(kAllChannels));
    if (!objs) {
        objs = [self loadAllChannelsFromLocal];
        [self setAllChannels:objs];
    }
    return objs;
}

- (void)setAllChannels:(NSArray *)allChannels
{
    objc_setAssociatedObject(self, (__bridge const void *)(kAllChannels), allChannels, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)fetchAllDataFromRemote
{
    NSDate* today = [[NSDate date] dateAtStartOfDay];
    NSDateFormatter* f = [[NSDateFormatter alloc] init];
    [f setDateFormat:SEER_API_DATE_FORMATE];
    NSString* dateString = [f stringFromDate:today];
    NSDictionary* query = @{
        @"name": @"start_dt",
        @"op": @">=",
        @"val": dateString,
    };
    NSString* resourcePath = [SEER_API_PROGRAMS stringByAppendingQueryParameters:@{@"q": query}];
    [appContext.objectManager loadObjectsAtResourcePath:resourcePath delegate:self];
}

- (void)fetchTodayDataFromRemoteByChannel:(Channel*)channel WithDelegate:(id)delegate
{
    NSDate* today = [[NSDate date] dateAtStartOfDay];
    NSDateFormatter* f = [[NSDateFormatter alloc] init];
    [f setDateFormat:SEER_API_DATE_FORMATE];
    NSString* dateString = [f stringFromDate:today];
    NSDictionary* queryDict = @{ @"filters": @[
                                        @{
                                        @"name": @"channel_id",
                                        @"op": @"==",
                                        @"val": channel.id
                                        },
                                        @{
                                        @"name": @"start_dt",
                                        @"op": @">=",
                                        @"val": dateString,
                                        },
                                    ]
                                };
    NSString* query = [queryDict JSONString];
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    [objectManager loadObjectsAtResourcePath:[SEER_API_PROGRAMS stringByAppendingQueryParameters:@{@"q": query}] delegate:delegate];
}

- (void)fetchTodayDataFromRemoteByChannel:(Channel*)channel
{
    [self fetchTodayDataFromRemoteByChannel:channel WithDelegate:self];
}

- (NSArray*)loadAllChannelsFromLocal
{
    return [self loadData:[Channel class] FromLocalWithBlock:^(NSFetchRequest* request) {
        NSSortDescriptor* sort = [NSSortDescriptor sortDescriptorWithKey:@"id" ascending:YES];
        [request setSortDescriptors:@[sort]];
    }];
}

- (NSArray*)loadTodayProgramsFromLocal
{
    return [self loadData:[Program class] FromLocalWithBlock:^(NSFetchRequest* request) {
        NSSortDescriptor* sort = [NSSortDescriptor sortDescriptorWithKey:@"startDate" ascending:NO];
        NSDate* today = [[NSDate date] dateAtStartOfDay];
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"startDate >= %@", today];
        [request setSortDescriptors:@[sort]];
        [request setPredicate:predicate];
    }];
}

- (NSArray*)loadData:(Class)class FromLocalWithBlock:(ZZFetchRequestBlock)block
{
    NSFetchRequest *request = [class fetchRequest];
    block(request);
    return [class objectsWithFetchRequest:request];
}

- (id)loadObject:(Class)class ById:(NSInteger)objId
{
    NSFetchRequest* request = [class fetchRequest];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"id == %d", objId];
    [request setPredicate:predicate];
    return [class objectWithFetchRequest:request];
}

- (Channel*)loadChannelById:(NSInteger)channelId
{
    return [self loadObject:[Channel class] ById:channelId];
}

- (Program*)loadProgramById:(NSInteger)programId
{
    return [self loadObject:[Program class] ById:programId];
}

#pragma mark RKObjectLoaderDelegate methods

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObject:(id)object
{
    NSArray* objects = [self loadTodayProgramsFromLocal];
    self.allPrograms = objects;
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    NSLog(@"in didFailWithError: %@", error);
}

@end
