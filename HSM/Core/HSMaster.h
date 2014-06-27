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
#import "HSEventManager.h"
#import "HSNetworkManager.h"
#import "HSPassManager.h"
#import "HSTools.h"

#pragma mark - typedef

typedef enum HSREsourceIndex : NSInteger
{
    kResourceAgendaPause        = 0,
    kResourceEventSingleContent = 1,
    kResourceEventSingleFooter  = 2,
    kResourceEventSingleInfo    = 3,
    kResourceEventSingleText    = 4,
    kResourcePassPickerView     = 5,
    kResourcePassHeaderView     = 6,
    kResourcePassFormSection    = 7,
    kResourcePassFormPickerCell = 8,
    kResourcePassFormPaymentCell= 9,
    kResourcePassFormCell       = 10,
    kResourcePassFormAddCell    = 11,
    kResourcePassFormEditCell   = 12
}
HSREsourceIndex;

#pragma mark - Interface

@interface HSMaster : NSObject

// Singletons
+ (HSMaster *) core;
+ (HSAnalytics *) analytics;
+ (HSRestClient *) rest;
+ (HSLocalClient *) local;
+ (HSEventManager *) events;
+ (HSNetworkManager *) network;
+ (HSPassManager *) passes;
+ (HSTools *) tools;

// Properties
@property (nonatomic, strong) NSDateFormatter *stringConverter;
@property (nonatomic, strong) NSDateFormatter *humamFormatter;

#pragma mark - Methods

- (UIView *) resourceAtIndex:(HSREsourceIndex) index;

@end
