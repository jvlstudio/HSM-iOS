//
//  HSRestClient.h
//  HSM
//
//  Created by Felipe Ricieri on 16/06/14.
//  Copyright (c) 2014 ikomm Digital Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - Typedef

#define HS_HTTP_METHODS @[@"GET", @"POST", @"PUT", @"PATCH"]

typedef enum HTTPMethod : NSInteger
{
    kHTTPMethodGET      = 0,
    kHTTPMethodPOST     = 1,
    kHTTPMethodPUT      = 2,
    kHTTPMethodPATCH    = 3
}
HTTPMethod;

#pragma mark - Interface

@interface HSRestClient : NSObject

- (void) loadInBackground:(BOOL) option;

- (void) events:(void(^)(BOOL succeed, NSDictionary *result))block;
- (void) books:(void(^)(BOOL succeed, NSDictionary *result))block;
- (void) magazines:(void(^)(BOOL succeed, NSDictionary *result))block;

- (void) ads:(void(^)(BOOL succeed, NSDictionary *result))block;
- (void) adClicked:(NSString *) adId completion:(void(^)(BOOL succeed, NSDictionary *result))block;
- (void) adViewed:(NSString *) adId completion:(void(^)(BOOL succeed, NSDictionary *result))block;

@end
