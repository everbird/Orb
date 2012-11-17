//
//  AppConfig.h
//  Orb
//
//  Created by everbird on 11/17/12.
//  Copyright (c) 2012 everbird. All rights reserved.
//

#ifndef Orb_AppConfig_h
#define Orb_AppConfig_h

#define ENVIRONMENT_LOCALDEV                    0
#define ENVIRONMENT_DEV                         1
#define ENVIRONMENT_RELEASE                     2

#ifndef ENVIRONMENT
#define ENVIRONMENT     ENVIRONMENT_LOCALDEV
#endif

#if ENVIRONMENT == ENVIRONMENT_LOCALDEV

#import "LocalConfig.h"

#elif ENVIRONMENT == ENVIRONMENT_DEV

#define SEER_API_BASE_URL       @"http://cidar:8100"
#define SEER_LOCAL_STORE        @"SeerLocalDev.sqlite"

#elif ENVIRONMENT == ENVIRONMENT_RELEASE

#define SEER_API_BASE_URL       @"http://seer.everbird.net"
#define SEER_LOCAL_STORE        @"Seer.sqlite"

#endif


#endif
