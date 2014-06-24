//
//  HSLecture.h
//  HSM
//
//  Created by Felipe Ricieri on 16/06/14.
//  Copyright (c) 2014 ikomm Digital Solutions. All rights reserved.
//

#import "HSEvent.h"

#pragma mark - Typedef

typedef enum HSLectureType : NSInteger
{
    kTypeLecture    = 0,
    kTypePause      = 1,
    kTypePromotion  = 2
}
HSLectureType;
#define HS_LECTURE_TYPE_LABELS  @[ @"speech", @"break", @"session" ]

#pragma mark - Interface

@interface HSLecture : NSObject
{
    HSLectureType type;
    HSEvent *event;
    NSString *title;
    NSString *subtitle;
    NSDate *date;
    NSDate *hourStart;
    NSDate *hourEnd;
}

@property (nonatomic) HSLectureType type;
@property (nonatomic, strong) HSEvent *event;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subtitle;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSDate *hourStart;
@property (nonatomic, strong) NSDate *hourEnd;

#pragma mark - Methods

+ (HSLectureType) typeForLabel:(NSString *) label;
+ (NSDate *) dateWithValue:(NSString *) value;
+ (NSDate *) hourWithValue:(NSString *) value;

@end
