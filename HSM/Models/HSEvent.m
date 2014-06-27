//
//  HSEvent.m
//  HSM
//
//  Created by Felipe Ricieri on 16/06/14.
//  Copyright (c) 2014 ikomm Digital Solutions. All rights reserved.
//

#import "HSEvent.h"

@implementation HSEvent

@synthesize uniqueId;
@synthesize name, slug;
@synthesize shortDescription, largeDescription;
@synthesize local;
@synthesize dates, hours;
@synthesize datePretty;
@synthesize pictureList, pictureSingle;

#pragma mark - Methods

+ (HSEvent *) simpleEventWithDictionary:(NSDictionary *) dict
{
    HSEvent *event  = [HSEvent new];
    
    event.uniqueId  = [dict objectForKey:@"id"];
    event.name      = [dict objectForKey:@"name"];
    event.slug      = [dict objectForKey:@"slug"];
    
    return event;
}
+ (NSArray *) dateArrayFromRESTObject:(NSArray *) array
{
    NSMutableArray *newArray = [NSMutableArray array];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd/MM/yyyy"];
    for (NSString *string in array) {
        NSDate *date = [df dateFromString:string];
        [newArray addObject:date];
    }
    return newArray;
}

@end
