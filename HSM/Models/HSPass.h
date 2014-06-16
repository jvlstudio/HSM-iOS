//
//  HSPass.h
//  HSM
//
//  Created by Felipe Ricieri on 16/06/14.
//  Copyright (c) 2014 ikomm Digital Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

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
    NSString *name;
    NSString *description;
    NSString *value;
    NSString *valuePromo;
}

@property (nonatomic) HSPassColor color;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *value;
@property (nonatomic, strong) NSString *valuePromo;

@end
