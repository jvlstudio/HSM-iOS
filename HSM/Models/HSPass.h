//
//  HSPass.h
//  HSM
//
//  Created by Felipe Ricieri on 16/06/14.
//  Copyright (c) 2014 ikomm Digital Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSEvent.h"

#pragma mark - Typedef

typedef enum HSPassColor : NSInteger
{
    kColorRed   = 0,
    kColorGreen = 1,
    kColorGold  = 2
}
HSPassColor;

#pragma mark - Interface

@interface HSPass : NSObject
{
    HSPassColor color;
    HSEvent *event;
    NSString *name;
    NSString *slug;
    NSString *description;
    NSString *value;
    NSString *valuePromo;
    NSString *validTo;
    NSString *email;
    NSDictionary *metadata; // days, dates, show_dates, is_multiple
}

@property (nonatomic) HSPassColor color;
@property (nonatomic, strong) HSEvent *event;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *slug;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *value;
@property (nonatomic, strong) NSString *valuePromo;
@property (nonatomic, strong) NSString *validTo;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSDictionary *metadata;

#pragma mark - Methods

+ (HSPassColor) colorForLabel:(NSString *) label;

@end
