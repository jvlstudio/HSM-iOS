//
//  HSMagazine.h
//  HSM
//
//  Created by Felipe Ricieri on 20/06/14.
//  Copyright (c) 2014 ikomm Digital Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSMagazine : NSObject
{
    NSString *uniqueId;
    NSString *name;
    NSString *slug;
    NSString *edition;
}

@property (nonatomic, strong) NSString *uniqueId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *slug;
@property (nonatomic, strong) NSString *edition;

@end
