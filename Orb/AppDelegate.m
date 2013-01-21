//
//  AppDelegate.m
//  Orb
//
//  Created by everbird on 10/20/12.
//  Copyright (c) 2012 everbird. All rights reserved.
//

#import "AppDelegate.h"

#import <RestKit/RestKit.h>
#import <RestKit/CoreData.h>
#import "AppCommon.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    // Setup for RestKit
    NSURL *baseURL = [NSURL URLWithString:SEER_API_BASE_URL];
    RKObjectManager* objectManager = [RKObjectManager managerWithBaseURL:baseURL];
    
    // Enable Activity Indicator Spinner
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    // Initialize managed object store
    NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
    objectManager.managedObjectStore = managedObjectStore;
    
    RKEntityMapping* channelMapping = [RKEntityMapping mappingForEntityForName:@"Channel" inManagedObjectStore:managedObjectStore];
    channelMapping.identificationAttributes = @[@"id"];
    [channelMapping addAttributeMappingsFromArray:@[@"id", @"name", @"priority"]];
    
    RKEntityMapping* programMapping = [RKEntityMapping mappingForEntityForName:@"Program" inManagedObjectStore:managedObjectStore];
    programMapping.identificationAttributes = @[@"id"];
    [programMapping addAttributeMappingsFromArray:@[@"id", @"name", @"length", @"datenum"]];
    [programMapping addAttributeMappingsFromDictionary:@{
         @"channel_id": @"channelId",
         @"start_dt": @"startDate",
         @"update_dt": @"updateDate",
         @"end_dt": @"endDate",
     }];
    
    [programMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"channel"
                                                                                   toKeyPath:@"channel"
                                                                                 withMapping:channelMapping]];
    
    
    [RKObjectMapping addDefaultDateFormatterForString:@"yyyy-MM-dd'T'HH:mm:ss'Z'" inTimeZone:[NSTimeZone timeZoneWithAbbreviation:TIMEZONE]];
    
    RKResponseDescriptor *channelResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:channelMapping
                                                                                              pathPattern:SEER_API_CHANNELS
                                                                                                  keyPath:@"objects"
                                                                                              statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];

    RKResponseDescriptor *programResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:programMapping
                                                                                              pathPattern:SEER_API_PROGRAMS
                                                                                                  keyPath:@"objects"
                                                                                              statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [objectManager addResponseDescriptorsFromArray:@[
        channelResponseDescriptor,
        programResponseDescriptor
     ]];
    
    /**
     Complete Core Data stack initialization
     */
    [managedObjectStore createPersistentStoreCoordinator];
    NSString *storePath = [RKApplicationDataDirectory() stringByAppendingPathComponent:SEER_LOCAL_STORE];
    NSError *error;
    NSPersistentStore *persistentStore = [managedObjectStore addSQLitePersistentStoreAtPath:storePath fromSeedDatabaseAtPath:nil withConfiguration:nil options:nil error:&error];
    NSAssert(persistentStore, @"Failed to add persistent store with error: %@", error);
    
    // Create the managed object contexts
    [managedObjectStore createManagedObjectContexts];
    
    // Configure a managed object cache to ensure we do not create duplicate objects
    managedObjectStore.managedObjectCache = [[RKInMemoryManagedObjectCache alloc] initWithManagedObjectContext:managedObjectStore.persistentStoreManagedObjectContext];
    
    // Setup MagicalRecord
    [MagicalRecord setupCoreDataStack];
    
    // Global context init
    appContext.rootVC = (UINavigationController*)self.window.rootViewController;
    
    RKObjectManager* syncObjectManager = [RKObjectManager managerWithBaseURL:baseURL];
    syncObjectManager.managedObjectStore = managedObjectStore;
    [syncObjectManager addResponseDescriptorsFromArray:@[
        channelResponseDescriptor,
        programResponseDescriptor
     ]];
    appContext.syncObjectManager = syncObjectManager;
    
    RKManagedObjectImporter* importer = [[RKManagedObjectImporter alloc] initWithPersistentStore:persistentStore];
    appContext.importer = importer;
    
    NSError* importerError;
    NSString* jsonFilePath = [[NSBundle mainBundle] pathForResource:@"objects" ofType:@"json"];
    [appContext.importer importObjectsFromItemAtPath:jsonFilePath
                                         withMapping:programMapping
                                             keyPath:@"objects"
                                               error:&importerError];
    NSError* finishError;
    BOOL finish = [appContext.importer finishImporting:&finishError];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSLog(@"got local notificatioin: %@", notification);
}

@end
