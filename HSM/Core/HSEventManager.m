//
//  HSEventManager.m
//  HSM
//
//  Created by Felipe Ricieri on 16/06/14.
//  Copyright (c) 2014 ikomm Digital Solutions. All rights reserved.
//

#import "HSEventManager.h"

@implementation HSEventManager

#pragma mark - Methods

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
    
    return eventObjects;
}
- (HSEvent *) eventForId:(NSString *) eventId
{
    NSArray *events = [self events];
    NSDictionary *eventDict = nil;
    for (NSDictionary *dict in events)
        if ([[dict objectForKey:@"id"] isEqualToString:eventId])
            eventDict = dict;
    
    // event
    HSEvent *event = [HSEvent new];
    event.uniqueId = [eventDict objectForKey:@"id"];
    event.name = [eventDict objectForKey:@"name"];
    event.shortDescription = [eventDict objectForKey:@"tiny_description"];
    event.largeDescription = [eventDict objectForKey:@"description"];
    event.local = [eventDict objectForKey:@"local"];
    event.dates = [eventDict objectForKey:@"dates"];
    
    return event;
}

@end
