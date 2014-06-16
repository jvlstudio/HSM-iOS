//
//  HSRestClient.h
//  HSM
//
//  Created by Felipe Ricieri on 16/06/14.
//  Copyright (c) 2014 ikomm Digital Solutions. All rights reserved.
//

#pragma mark - Typedef

#define CH_HTTP_METHODS @[@"GET", @"POST", @"PUT", @"PATCH"]

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

- (void) userSignIn:(NSString*) login password:(NSString*) password completion:(void(^)(BOOL succeed, NSDictionary *result))block;

@end
