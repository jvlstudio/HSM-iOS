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
#import "HSLecture.h"
#import "HSPass.h"
#import "HSPanelist.h"

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

@property (nonatomic, strong) UIView *hudView;

#pragma mark -  Ads Methods

- (BOOL) hasAdWithType:(HSAdType) type;
- (void) setAdClickedInBackground:(HSAd *) advertising;
- (void) setAdViewedInBackground:(HSAd *) advertising;

#pragma mark - Content Methods

- (void) saveEvents:(NSArray *) data;
- (NSArray *) events;
- (NSArray *) nextEvents;
- (NSArray *) previousEvents;
- (HSEvent *) eventForId:(NSString *) eventId;

- (void) saveBooks:(NSArray *) data;
- (NSArray *) books;
- (HSBook *) bookForId:(NSString *) bookId;

- (void) saveMagazines:(NSArray *) data;
- (NSArray *) magazines;

- (void) saveAgenda:(NSArray *) data forEvent:(NSString *) eventId;
- (NSArray *) agendaForEvent:(NSString *) eventId;

- (void) savePanelists:(NSArray *) data forEvent:(NSString *) eventId;
- (NSArray *) panelistsForEvent:(NSString *) eventId;

- (void) savePasses:(NSArray *) data forEvent:(NSString *) eventId;
- (NSArray *) passesForEvent:(NSString *) eventId;

@end
