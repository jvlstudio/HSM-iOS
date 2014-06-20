//
//  HSLocalClient.h
//  HSM
//
//  Created by Felipe Ricieri on 20/06/14.
//  Copyright (c) 2014 ikomm Digital Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HSAd.h"
#import "HSEvent.h"
#import "HSBook.h"
#import "HSMagazine.h"

#pragma mark - Typedef

typedef enum HSAdType : NSInteger
{
    kTypeHome           = 0,
    kTypeFooter         = 1,
    kTypeExpand         = 2,
    kTypeSuperstitial   = 3
}
HSAdType;

#pragma mark - Interface

@interface HSLocalClient : NSObject

#pragma mark -  Ads Methods

- (BOOL) hasAdWithType:(HSAdType) type;
- (void) setAdClickedInBackground:(HSAd *) advertising;
- (void) setAdViewedInBackground:(HSAd *) advertising;

#pragma mark - Events Methods

- (void) saveEvents:(NSArray *) events;
- (NSArray *) events;
- (NSArray *) nextEvents;
- (NSArray *) previousEvents;
- (HSEvent *) eventForId:(NSString *) eventId;

#pragma mark - Books Methods

- (NSArray *) books;
- (HSBook *) bookForId:(NSString *) bookId;

#pragma mark - Magazines Methods

- (NSArray *) magazines;

@end
