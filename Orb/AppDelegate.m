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
    RKObjectManager* objectManager = [RKObjectManager managerWithBaseURLString:SEER_API_BASE_URL];
    objectManager.client.requestQueue.showsNetworkActivityIndicatorWhenBusy = YES;
    NSString* databaseName = SEER_LOCAL_STORE;
    objectManager.objectStore = [RKManagedObjectStore objectStoreWithStoreFilename:databaseName];
    
    RKManagedObjectMapping* channelMapping = [RKManagedObjectMapping mappingForEntityWithName:@"Channel" inManagedObjectStore:objectManager.objectStore];
    channelMapping.primaryKeyAttribute = @"id";
    [channelMapping mapKeyPath:@"id" toAttribute:@"id"];
    [channelMapping mapKeyPath:@"name" toAttribute:@"name"];
    
    RKManagedObjectMapping* programMapping = [RKManagedObjectMapping mappingForEntityWithName:@"Program" inManagedObjectStore:objectManager.objectStore];
    programMapping.primaryKeyAttribute = @"id";
    [programMapping mapKeyPathsToAttributes:@"id", @"id",
     @"name", @"name",
     @"length", @"length",
     @"datenum", @"datenum",
     @"channel_id", @"channelId",
     @"start_dt", @"startDate",
     @"update_dt", @"updateDate",
     nil];
    [programMapping mapRelationship:@"channel" withMapping:channelMapping];
    
    [RKObjectMapping addDefaultDateFormatterForString:@"yyyy-MM-dd'T'HH:mm:ss'Z'" inTimeZone:[NSTimeZone timeZoneWithAbbreviation:TIMEZONE]];
    
    [objectManager.mappingProvider registerMapping:channelMapping withRootKeyPath:@"objects"];
    [objectManager.mappingProvider registerMapping:programMapping withRootKeyPath:@"objects"];
    
    [objectManager.mappingProvider setObjectMapping:channelMapping forResourcePathPattern:SEER_API_PROGRAM];
    [objectManager.mappingProvider setObjectMapping:channelMapping forResourcePathPattern:SEER_API_ALL_CHANNELS];
    
    [objectManager.mappingProvider setObjectMapping:programMapping forResourcePathPattern:SEER_API_PROGRAMS];
    
    // Global context init
    appContext.rootVC = (UINavigationController*)self.window.rootViewController;
    
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
