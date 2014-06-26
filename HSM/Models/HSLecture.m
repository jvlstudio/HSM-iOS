//
//  HSLecture.m
//  HSM
//
//  Created by Felipe Ricieri on 16/06/14.
//  Copyright (c) 2014 ikomm Digital Solutions. All rights reserved.
//

#import "HSLecture.h"

@implementation HSLecture

@synthesize type;
@synthesize event, panelist;
@synthesize title, subtitle, text;
@synthesize date;
@synthesize hourStart, hourEnd;
@synthesize themeTitle, themeText;

#pragma mark - Methods

+ (HSLectureType) typeForLabel:(NSString *) label
{
    HSLectureType lectureType;
    if ([label isEqualToString:@"speech"])
        lectureType = kTypeLecture;
    else if ([label isEqualToString:@"break"])
        lectureType = kTypePause;
    else if ([label isEqualToString:@"session"])
        lectureType = kTypePromotion;
    
    return lectureType;
}
+ (NSDate *)dateWithValue:(NSString *)value
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd/MM/yyyy"];
    NSDate *date = [df dateFromString:value];
    return date;
}
+ (NSDate *)hourWithValue:(NSString *)value
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [df dateFromString:value];
    return date;
}

@end
