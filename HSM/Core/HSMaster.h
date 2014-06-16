//
//  HSMaster.h
//  HSM
//
//  Created by Felipe Ricieri on 16/06/14.
//  Copyright (c) 2014 ikomm Digital Solutions. All rights reserved.
//

#import "HSAnalytics.h"
#import "HSRestClient.h"
#import "HSTools.h"
#import "HSAdManager.h"
#import "HSEventManager.h"

@interface HSMaster : NSObject

// Singletons
+ (HSMaster *) core;
+ (HSAnalytics *) analytics;
+ (HSRestClient *) rest;
+ (HSTools *) tools;
+ (HSAdManager *) ads;
+ (HSEventManager *) events;

// Properties
@property (nonatomic, strong) NSDateFormatter *stringConverter;
@property (nonatomic, strong) NSDateFormatter *humamFormatter;

@end
