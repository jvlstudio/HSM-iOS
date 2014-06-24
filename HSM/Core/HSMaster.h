//
//  HSMaster.h
//  HSM
//
//  Created by Felipe Ricieri on 16/06/14.
//  Copyright (c) 2014 ikomm Digital Solutions. All rights reserved.
//

#import "HSAnalytics.h"
#import "HSRestClient.h"
#import "HSLocalClient.h"
#import "HSNetworkManager.h"
#import "HSTools.h"

@interface HSMaster : NSObject

// Singletons
+ (HSMaster *) core;
+ (HSAnalytics *) analytics;
+ (HSRestClient *) rest;
+ (HSLocalClient *) local;
+ (HSNetworkManager *) network;
+ (HSTools *) tools;

// Properties
@property (nonatomic, strong) NSDateFormatter *stringConverter;
@property (nonatomic, strong) NSDateFormatter *humamFormatter;

#pragma mark - Methods

- (UIView *) viewFromXIBAtIndex:(NSInteger) index;

@end
