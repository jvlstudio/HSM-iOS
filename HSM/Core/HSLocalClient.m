//
//  HSLocalClient.m
//  HSM
//
//  Created by Felipe Ricieri on 20/06/14.
//  Copyright (c) 2014 ikomm Digital Solutions. All rights reserved.
//

#import "HSLocalClient.h"

@implementation HSLocalClient

@synthesize hudView;

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

#pragma mark - Content Methods

// events
- (void) saveEvents:(NSArray *)data
{
    if (data)
        [[HSMaster tools] propertyListWrite:data forFileName:HS_PLIST_EVENTS];
}
- (NSArray *) events
{
    NSArray *localData = [[HSMaster tools] propertyListRead:HS_PLIST_EVENTS];
    NSMutableArray *newData = [NSMutableArray array];
    for (NSDictionary *dict in localData)
    {
        // object
        HSEvent *object = [HSEvent new];
        object.uniqueId = [dict objectForKey:@"id"];
        object.name = [dict objectForKey:@"name"];
        object.shortDescription = [dict objectForKey:@"tiny_description"];
        object.largeDescription = [dict objectForKey:@"description"];
        object.local = [dict objectForKey:@"locale"];
        //object.dates = [dict objectForKey:@"dates"];
        object.hours = [dict objectForKey:@"hours"];
        
        [newData addObject:object];
    }
    
    return newData;
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

// books
- (void) saveBooks:(NSArray *)data
{
    if (data)
        [[HSMaster tools] propertyListWrite:data forFileName:HS_PLIST_BOOKS];
}
- (NSArray *) books
{
    NSArray *localData = [[HSMaster tools] propertyListRead:HS_PLIST_BOOKS];
    NSMutableArray *newData = [NSMutableArray array];
    for (NSDictionary *dict in localData)
    {
        // object
        HSBook *object = [HSBook new];
        object.uniqueId = [dict objectForKey:@"id"];
        object.title = [dict objectForKey:@"title"];
        object.subtitle = [dict objectForKey:@"subtitle"];
        object.description = [dict objectForKey:@"description"];
        object.authorName = [dict objectForKey:@"author_name"];
        object.authorDescription = [dict objectForKey:@"author_description"];
        object.price = [dict objectForKey:@"price"];
        object.link = [dict objectForKey:@"link"];
        
        [newData addObject:object];
    }
    
    return newData;
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

// magazines
- (void) saveMagazines:(NSArray *)data
{
    if (data)
        [[HSMaster tools] propertyListWrite:data forFileName:HS_PLIST_MAGAZINES];
}
- (NSArray *) magazines
{
    NSArray *localData = [[HSMaster tools] propertyListRead:HS_PLIST_MAGAZINES];
    NSMutableArray *newData = [NSMutableArray array];
    for (NSDictionary *dict in localData)
    {
        // object
        HSMagazine *object = [HSMagazine new];
        object.uniqueId = [dict objectForKey:@"id"];
        object.name = [dict objectForKey:@"title"];
        object.slug = [dict objectForKey:@"slug"];
        object.edition = [dict objectForKey:@"edition"];
        
        [newData addObject:object];
    }
    
    return newData;
}

// agenda
- (void) saveAgenda:(NSArray *)data forEvent:(NSString *)eventId
{
    if (data) {
        NSMutableDictionary *plist = [[HSMaster tools] propertyListRead:HS_PLIST_AGENDA];
        NSString *key = [NSString stringWithFormat:@"event_%@", eventId];
        [plist setObject:data forKey:key];
        [[HSMaster tools] propertyListWrite:plist forFileName:HS_PLIST_AGENDA];
    }
}
- (NSArray *) agendaForEvent:(NSString *) eventId
{
    NSDictionary *plist = [[HSMaster tools] propertyListRead:HS_PLIST_AGENDA];
    NSArray *localData  = [plist objectForKey:[NSString stringWithFormat:@"event_%@", eventId]];
    NSMutableArray *newData = [NSMutableArray array];
    
    if (localData && [localData count] > 0) {
        for (NSDictionary *dict in localData)
        {
            // object
            HSLecture *object = [HSLecture new];
            HSEvent *event  = [HSEvent simpleEventWithDictionary:[dict objectForKey:@"event"]];
            object.type     = [HSLecture typeForLabel:[dict objectForKey:@"type"]];
            object.event    = event;
            object.title    = [dict objectForKey:@"label"];
            object.subtitle = [dict objectForKey:@"sublabel"];
            object.date     = [HSLecture dateWithValue:[[dict objectForKey:@"date"] objectForKey:@"date"]];
            object.hourStart= [HSLecture hourWithValue:[[dict objectForKey:@"date"] objectForKey:@"start"]];
            object.hourEnd  = [HSLecture hourWithValue:[[dict objectForKey:@"date"] objectForKey:@"end"]];
            
            [newData addObject:object];
        }
    }
    
    return newData;
}

// panelist
- (void) savePanelists:(NSArray *)data forEvent:(NSString *)eventId
{
    if (data) {
        NSMutableDictionary *plist = [[HSMaster tools] propertyListRead:HS_PLIST_PANELISTS];
        NSString *key = [NSString stringWithFormat:@"event_%@", eventId];
        [plist setObject:data forKey:key];
        [[HSMaster tools] propertyListWrite:plist forFileName:HS_PLIST_PANELISTS];
    }
}
- (NSArray *) panelistsForEvent:(NSString *) eventId
{
    NSDictionary *plist = [[HSMaster tools] propertyListRead:HS_PLIST_PANELISTS];
    NSArray *localData  = [plist objectForKey:[NSString stringWithFormat:@"event_%@", eventId]];
    NSMutableArray *newData = [NSMutableArray array];
    
    if (localData && [localData count] > 0) {
        for (NSDictionary *dict in localData)
        {
            // object
            HSPanelist *object  = [HSPanelist new];
            object.uniqueId     = [dict objectForKey:@"id"];
            object.name         = [dict objectForKey:@"name"];
            object.slug         = [dict objectForKey:@"slug"];
            object.description  = [dict objectForKey:@"description"];
            object.pictureURL   = [dict objectForKey:@"picture"];
            
            [newData addObject:object];
        }
    }
    
    MBProgressHUD *hud;
    if ([localData count] == 0 && hudView)
        hud = [MBProgressHUD showHUDAddedTo:hudView animated:YES];
    
    // update..
    [[HSMaster rest] loadInBackground:YES];
    [[HSMaster rest] panelistsForEvent:eventId completion:^(BOOL succeed, NSDictionary *result) {
        if (succeed) {
            if (result != nil) {
                NSMutableDictionary *mdict = [[HSMaster tools] propertyListRead:HS_PLIST_PANELISTS];
                NSString *key = [NSString stringWithFormat:@"panelist_%@", eventId];
                [mdict setObject:[result objectForKey:@"data"] forKey:key];
                [[HSMaster tools] propertyListWrite:mdict forFileName:HS_PLIST_PANELISTS];
            }
        }
        if (hud)
            [hud hide:YES];
    }];
    
    return newData;
}

// passes
- (void) savePasses:(NSArray *)data forEvent:(NSString *)eventId
{
    if (data) {
        NSMutableDictionary *plist = [[HSMaster tools] propertyListRead:HS_PLIST_PASSES];
        NSString *key = [NSString stringWithFormat:@"event_%@", eventId];
        [plist setObject:data forKey:key];
        [[HSMaster tools] propertyListWrite:plist forFileName:HS_PLIST_PASSES];
    }
}
- (NSArray *) passesForEvent:(NSString *) eventId
{
    NSDictionary *plist = [[HSMaster tools] propertyListRead:HS_PLIST_PASSES];
    NSArray *localData  = [plist objectForKey:[NSString stringWithFormat:@"event_%@", eventId]];
    NSMutableArray *newData = [NSMutableArray array];
    
    if (localData && [localData count] > 0) {
        for (NSDictionary *dict in localData)
        {
            // object
            HSPass *object      = [HSPass new];
            object.color        = [HSPass colorForLabel:[dict objectForKey:@"color"]];
            object.name         = [dict objectForKey:@"name"];
            object.slug         = [dict objectForKey:@"slug"];
            object.description  = [dict objectForKey:@"description"];
            object.value        = [dict objectForKey:@"price_from"];
            object.valuePromo   = [dict objectForKey:@"price_to"];
            object.validTo      = [dict objectForKey:@"valid_to"];
            object.email        = [dict objectForKey:@"email"];
            object.metadata     = [dict objectForKey:@"meta"];
            
            [newData addObject:object];
        }
    }
    
    MBProgressHUD *hud;
    if ([localData count] == 0 && hudView)
        hud = [MBProgressHUD showHUDAddedTo:hudView animated:YES];
    
    // update..
    [[HSMaster rest] loadInBackground:YES];
    [[HSMaster rest] passesForEvent:eventId completion:^(BOOL succeed, NSDictionary *result) {
        if (succeed) {
            if (result != nil) {
                NSMutableDictionary *mdict = [[HSMaster tools] propertyListRead:HS_PLIST_PASSES];
                NSString *key = [NSString stringWithFormat:@"passes_%@", eventId];
                [mdict setObject:[result objectForKey:@"data"] forKey:key];
                [[HSMaster tools] propertyListWrite:mdict forFileName:HS_PLIST_PASSES];
            }
        }
        if (hud)
            [hud hide:YES];
    }];
    
    return newData;
}

@end
