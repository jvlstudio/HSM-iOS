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
    NSString *shortDescription;
    NSString *largeDescription;
    NSString *local;
    NSArray *dates; // array of NSDate
}

@property (nonatomic, strong) NSString *uniqueId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *shortDescription;
@property (nonatomic, strong) NSString *largeDescription;
@property (nonatomic, strong) NSString *local;
@property (nonatomic, strong) NSArray *dates;

@end
