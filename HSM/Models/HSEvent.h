//
//  HSEvent.h
//  HSM
//
//  Created by Felipe Ricieri on 16/06/14.
//  Copyright (c) 2014 ikomm Digital Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSEvent : NSObject
{
    NSString *uniqueId;
    NSString *name;
    NSString *slug;
    NSString *shortDescription;
    NSString *largeDescription;
    NSString *local;
    NSArray *dates; // array of NSDate
    NSString *datePretty;
    NSString *hours;
    NSString *picture;
}

@property (nonatomic, strong) NSString *uniqueId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *slug;
@property (nonatomic, strong) NSString *shortDescription;
@property (nonatomic, strong) NSString *largeDescription;
@property (nonatomic, strong) NSString *local;
@property (nonatomic, strong) NSArray *dates;
@property (nonatomic, strong) NSString *datePretty;
@property (nonatomic, strong) NSString *hours;
@property (nonatomic, strong) NSString *picture;

#pragma mark - Methods

+ (HSEvent *) simpleEventWithDictionary:(NSDictionary *) dict;
+ (NSArray *) dateArrayFromRESTObject:(NSArray *) array;

@end
