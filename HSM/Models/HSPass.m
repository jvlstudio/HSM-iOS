//
//  HSPass.m
//  HSM
//
//  Created by Felipe Ricieri on 16/06/14.
//  Copyright (c) 2014 ikomm Digital Solutions. All rights reserved.
//

#import "HSPass.h"

@implementation HSPass

@synthesize color;
@synthesize event;
@synthesize name, slug, description;
@synthesize value, valuePromo;
@synthesize validTo;
@synthesize email;
@synthesize metadata;

#pragma mark - Methods

+ (HSPassColor) colorForLabel:(NSString *) label
{
    HSPassColor color;
    if ([label isEqualToString:@"red"]) {
        color = kColorRed;
    }
    else if ([label isEqualToString:@"gold"]) {
        color = kColorGold;
    }
    else if ([label isEqualToString:@"green"]) {
        color = kColorGreen;
    }
    return color;
}

@end
