//
//  AppDefines.h
//  Orb
//
//  Created by everbird on 11/10/12.
//  Copyright (c) 2012 everbird. All rights reserved.
//

#ifndef Orb_AppDefines_h
#define Orb_AppDefines_h

#import <CoreData/CoreData.h>

typedef void (^ZZRunBlock)();
typedef void (^ZZFinishedBlock)();
typedef void (^ZZFailedBlock)(NSError* err);
typedef void (^ZZFetchRequestBlock)(NSFetchRequest* request);

#define N_RELOADED_DATA_REMOTE  @"remote.data.reloaded"

#endif
