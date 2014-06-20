//
//  HSLocalClient.m
//  HSM
//
//  Created by Felipe Ricieri on 20/06/14.
//  Copyright (c) 2014 ikomm Digital Solutions. All rights reserved.
//

#import "HSLocalClient.h"

@implementation HSLocalClient

#pragma mark - Ads Methods

- (BOOL) hasAdWithType:(HSAdType) type
{
    return NO;
}
- (void) setAdClickedInBackground:(HSAd *) advertising
{
    [[HSMaster rest] adClicked:advertising.uniqueId completion:^(BOOL succeed, NSDictionary *result) {
        if (succeed) {
            if (result != nil) {
                // send request only
            }
        }
        else {
            [[HSMaster tools] dialogWithMessage:@"Atenção" title:[result objectForKey:@"message"]];
        }
    }];
}
- (void) setAdViewedInBackground:(HSAd *) advertising
{
    [[HSMaster rest] adViewed:advertising.uniqueId completion:^(BOOL succeed, NSDictionary *result) {
        if (succeed) {
            if (result != nil) {
                // send request only
            }
        }
        else {
            [[HSMaster tools] dialogWithMessage:@"Atenção" title:[result objectForKey:@"message"]];
        }
    }];
}

#pragma mark - Events Methods

- (void) saveEvents:(NSArray *) events
{
    [[HSMaster tools] propertyListWrite:events forFileName:HS_PLIST_EVENTS];
}
- (NSArray *) events
{
    NSArray *events = [[HSMaster tools] propertyListRead:HS_PLIST_EVENTS];
    NSMutableArray *eventObjects = [NSMutableArray array];
    for (NSDictionary *eventDict in events)
    {
        // event
        HSEvent *event = [HSEvent new];
        event.uniqueId = [eventDict objectForKey:@"id"];
        event.name = [eventDict objectForKey:@"name"];
        event.shortDescription = [eventDict objectForKey:@"tiny_description"];
        event.largeDescription = [eventDict objectForKey:@"description"];
        event.local = [eventDict objectForKey:@"local"];
        event.dates = [eventDict objectForKey:@"dates"];
        
        [eventObjects addObject:event];
    }
    
    // update..
    [[HSMaster rest] loadInBackground:YES];
    [[HSMaster rest] events:^(BOOL succeed, NSDictionary *result) {
        [[HSMaster tools] propertyListWrite:[result objectForKey:@"data"] forFileName:HS_PLIST_EVENTS];
    }];
    
    return eventObjects;
}
- (NSArray*) nextEvents
{
    NSArray *events = [[HSMaster tools] propertyListRead:HS_PLIST_EVENTS];
    NSMutableArray *selected = [NSMutableArray array];
    
    for (NSDictionary *dict in events)
        if ([[dict objectForKey:@"did_happen"] isEqualToString:@"no"])
            [selected addObject:dict];
    
    return [selected copy];
}
- (NSArray*) previousEvents
{
    NSArray *events = [[HSMaster tools] propertyListRead:HS_PLIST_EVENTS];
    NSMutableArray *selected = [NSMutableArray array];
    
    for (NSDictionary *dict in events)
        if ([[dict objectForKey:@"did_happen"] isEqualToString:@"yes"])
            [selected addObject:dict];
    
    return [selected copy];
}
- (HSEvent *) eventForId:(NSString *) eventId
{
    NSArray *events = [self events];
    HSEvent *event = nil;
    for (HSEvent *eventSingle in events)
        if ([event.uniqueId isEqualToString:eventId])
            event = eventSingle;
    
    return event;
}

#pragma mark - Books Methods

- (NSArray *) books
{
    NSArray *books = [[HSMaster tools] propertyListRead:HS_PLIST_BOOKS];
    NSMutableArray *bookObjects = [NSMutableArray array];
    for (NSDictionary *bookDict in books)
    {
        // book
        HSBook *book = [HSBook new];
        book.uniqueId = [bookDict objectForKey:@"id"];
        book.title = [bookDict objectForKey:@"title"];
        book.subtitle = [bookDict objectForKey:@"subtitle"];
        book.description = [bookDict objectForKey:@"description"];
        book.authorName = [bookDict objectForKey:@"author_name"];
        book.authorDescription = [bookDict objectForKey:@"author_description"];
        book.price = [bookDict objectForKey:@"price"];
        book.link = [bookDict objectForKey:@"link"];
        
        [bookObjects addObject:book];
    }
    
    // update..
    [[HSMaster rest] loadInBackground:YES];
    [[HSMaster rest] books:^(BOOL succeed, NSDictionary *result) {
        [[HSMaster tools] propertyListWrite:[result objectForKey:@"data"] forFileName:HS_PLIST_BOOKS];
    }];
    
    return bookObjects;
}
- (HSBook *) bookForId:(NSString *) bookId
{
    NSArray *books = [self events];
    HSBook *book = nil;
    for (HSBook *bookSingle in books)
        if ([book.uniqueId isEqualToString:bookId])
            book = bookSingle;
    
    return book;
}

#pragma mark - Magazines Methods

- (NSArray *) magazines
{
    NSArray *magazines = [[HSMaster tools] propertyListRead:HS_PLIST_MAGAZINES];
    NSMutableArray *magazineObjects = [NSMutableArray array];
    for (NSDictionary *magazineDict in magazines)
    {
        // book
        HSMagazine *magazine = [HSMagazine new];
        magazine.uniqueId = [magazineDict objectForKey:@"id"];
        magazine.name = [magazineDict objectForKey:@"title"];
        magazine.slug = [magazineDict objectForKey:@"slug"];
        magazine.edition = [magazineDict objectForKey:@"edition"];
        
        [magazineObjects addObject:magazine];
    }
    
    // update..
    [[HSMaster rest] loadInBackground:YES];
    [[HSMaster rest] magazines:^(BOOL succeed, NSDictionary *result) {
        [[HSMaster tools] propertyListWrite:[result objectForKey:@"data"] forFileName:HS_PLIST_MAGAZINES];
    }];
    
    return magazineObjects;
}

@end
