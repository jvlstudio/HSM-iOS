//
//  HSBook.h
//  HSM
//
//  Created by Felipe Ricieri on 16/06/14.
//  Copyright (c) 2014 ikomm Digital Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSBook : NSObject
{
    NSString *uniqueId;
    NSString *title;
    NSString *subtitle;
    NSString *description;
    NSString *authorName;
    NSString *authorDescription;
    NSString *price;
    NSString *link;
}

@property (nonatomic, strong) NSString *uniqueId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subtitle;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *authorName;
@property (nonatomic, strong) NSString *authorDescription;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *link;

@end
