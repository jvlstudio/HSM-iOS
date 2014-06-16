//
//  HSAd.h
//  HSM
//
//  Created by Felipe Ricieri on 16/06/14.
//  Copyright (c) 2014 ikomm Digital Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSAd : NSObject
{
    NSString *uniqueId;
    NSString *image;
    NSString *link;
}

@property (nonatomic, strong) NSString *uniqueId;
@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *link;

@end
