//
//  HSPanelist.h
//  HSM
//
//  Created by Felipe Ricieri on 16/06/14.
//  Copyright (c) 2014 ikomm Digital Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSPanelist : NSObject
{
    NSString *uniqueId;
    NSString *name;
    NSString *slug;
    NSString *description;
    NSString *pictureURL;
}

@property (nonatomic, strong) NSString *uniqueId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *slug;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *pictureURL;

@end
