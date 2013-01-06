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
#import <objc/runtime.h>

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
    [appContext.objectManager getObjectsAtPath:SEER_API_PROGRAMS
                                    parameters:@{@"q": query}
                                       success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                           [self reloadAll];
                                       } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                           NSLog(@"It Failed: %@", error);
                                       }];
}

- (void)syncAllDataFromRemote
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
    [appContext.syncObjectManager getObjectsAtPath:SEER_API_PROGRAMS
                                    parameters:@{@"q": query}
                                       success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                           [self reloadAll];
                                       } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                           NSLog(@"It Failed: %@", error);
                                       }];
}

- (void)fetchTodayDataFromRemoteByChannel:(Channel*)channel
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
    [objectManager getObjectsAtPath:SEER_API_PROGRAMS
                         parameters:@{@"q": query}
                            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                [self reloadAll];
                            } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                NSLog(@"It Failed: %@", error);
                            }];
}

- (void)fetchCurrentProgramsFromRemote
{
    NSDate* now = [NSDate date];
    [self fetchProgramsFromRemoteByDate:now];
}

- (void)fetchProgramsFromRemoteByDate:(NSDate*)date
{
    NSDateFormatter* f = [[NSDateFormatter alloc] init];
    [f setDateFormat:SEER_API_DATE_FORMATE];
    NSString* dateString = [f stringFromDate:date];
    NSDictionary* queryDict = @{ @"filters": @[
                                    @{
                                        @"name": @"start_dt",
                                        @"op": @"<=",
                                        @"val": dateString,
                                    },
                                    @{
                                        @"name": @"end_dt",
                                        @"op": @">=",
                                        @"val": dateString,
                                    },
                                    ]
                                };
    NSString* query = [queryDict JSONString];
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    [objectManager getObjectsAtPath:SEER_API_PROGRAMS
                         parameters:@{@"q": query}
                            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                [self reloadAll];
                            }
                            failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                NSLog(@"It Failed: %@", error);
                            }];
}

- (void)fetchAllChannelsFromRemote
{
    [appContext.objectManager getObjectsAtPath:SEER_API_CHANNELS
                                    parameters:nil
                                       success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                           [self reloadAll];
                                       } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                           NSLog(@"It Failed: %@", error);
                                       }];
}

- (NSArray*)loadAllChannelsFromLocal
{
    return [self loadData:[Channel class] FromLocalWithBlock:^(NSFetchRequest* request) {
        NSSortDescriptor* sort = [NSSortDescriptor sortDescriptorWithKey:@"priority" ascending:NO];
        [request setSortDescriptors:@[sort]];
    }];
}

- (NSArray*)loadTodayProgramsFromLocal
{
    return [self loadData:[Program class] FromLocalWithBlock:^(NSFetchRequest* request) {
        NSSortDescriptor* sort = [NSSortDescriptor sortDescriptorWithKey:@"startDate" ascending:YES];
        NSDate* today = [[NSDate date] dateAtStartOfDay];
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"startDate >= %@", today];
        [request setSortDescriptors:@[sort]];
        [request setPredicate:predicate];
    }];
}

- (NSArray*)loadData:(Class)class FromLocalWithBlock:(ZZFetchRequestBlock)block
{
    const char * class_name = class_getName(class);
    NSString* className = [NSString stringWithCString:class_name encoding:NSUTF8StringEncoding];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:className];
    
    block(request);
    
    NSFetchedResultsController* fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                                               managedObjectContext:[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext
                                                                                                 sectionNameKeyPath:nil
                                                                                                          cacheName:nil];
    NSError *error = nil;
    BOOL fetchSuccessful = [fetchedResultsController performFetch:&error];
    
    if (!fetchSuccessful) {
        return nil;
    }
    return fetchedResultsController.fetchedObjects;
}

- (id)loadObject:(Class)class ById:(NSInteger)objId
{
    const char * class_name = class_getName(class);
    NSString* className = [NSString stringWithCString:class_name encoding:NSUTF8StringEncoding];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:className];
    request.fetchLimit = 1;
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"id == %d", objId];
    [request setPredicate:predicate];
    
    NSFetchedResultsController* fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                                               managedObjectContext:[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext
                                                                                                 sectionNameKeyPath:nil
                                                                                                          cacheName:nil];
    NSError *error = nil;
    BOOL fetchSuccessful = [fetchedResultsController performFetch:&error];
    
    NSArray* result = fetchedResultsController.fetchedObjects;
    if (!fetchSuccessful || [result count]==0) {
        return nil;
    }
    return [result objectAtIndex:0];
}

- (Channel*)loadChannelById:(NSInteger)channelId
{
    return [self loadObject:[Channel class] ById:channelId];
}

- (Program*)loadProgramById:(NSInteger)programId
{
    return [self loadObject:[Program class] ById:programId];
}

- (void)reloadAll
{
    NSArray* programs = [self loadTodayProgramsFromLocal];
    self.allPrograms = programs;
    
    NSArray* channels = [self loadAllChannelsFromLocal];
    self.allChannels = channels;
    
    if (programs && channels) {
        NSDictionary* userInfo = @{
            @"programs": programs,
            @"channels": channels,
        };
        [[NSNotificationCenter defaultCenter] postNotificationName:N_RELOADED_DATA_REMOTE object:nil userInfo:userInfo];
    }
}

@end
