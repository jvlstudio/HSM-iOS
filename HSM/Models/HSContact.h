//
//  HSContact.h
//  HSM
//
//  Created by Felipe Ricieri on 20/06/14.
//  Copyright (c) 2014 ikomm Digital Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSContact : NSObject
{
    NSString *name;
    NSString *email;
    NSString *phone;
    NSString *mobile;
    NSString *company;
    NSString *role;
    NSString *website;
    NSString *barcolor;
}

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *company;
@property (nonatomic, strong) NSString *role;
@property (nonatomic, strong) NSString *website;
@property (nonatomic, strong) NSString *barcolor;

@end
