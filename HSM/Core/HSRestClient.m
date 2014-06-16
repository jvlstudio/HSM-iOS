//
//  HSRestClient.m
//  HSM
//
//  Created by Felipe Ricieri on 16/06/14.
//  Copyright (c) 2014 ikomm Digital Solutions. All rights reserved.
//

#import "HSRestClient.h"

#pragma mark - Interface

@interface HSRestClient ()
- (void) sendRequestToURL:(NSURL*) url method:(HTTPMethod) method parameters:(NSDictionary*) parameters completion:(void(^)(BOOL succeed, NSDictionary *result))block;
@end

#pragma mark - Implementation

@implementation HSRestClient

#pragma mark - Methods

// sign an user up
- (void) userSignUp:(CHUser*) user completion:(void(^)(BOOL succeed, NSDictionary *result))block
{
    NSString *stringURL = [NSString stringWithFormat:@"%@/users", CH_REST_SOURCE];
    NSDictionary *params= @{@"user_name"    : user.userName,
                            @"user_email"   : user.userEmail,
                            @"user_birthday": @"20/06/1987",//user.userBirthday,
                            @"user_phone"   : user.userPhone,
                            @"user_gender"  : @"M",//user.userGender,
                            @"user_password": user.userPassword };
    // request..
    NSURL *url = [NSURL URLWithString:stringURL];
    [self sendRequestToURL:url method:kHTTPMethodPUT parameters:params completion:block];
}

#pragma mark - Private Methods

- (void) sendRequestToURL:(NSURL*) url method:(HTTPMethod) method parameters:(NSDictionary*) parameters completion:(void(^)(BOOL succeed, NSDictionary *result))block
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:120.0];
    
    [request setValue:CH_REST_ACCESS_TOKEN forHTTPHeaderField:CH_DEF_HTTP_TOKEN];
    [request setHTTPMethod:[CH_HTTP_METHODS objectAtIndex:method]];
    if([[CHMaster user] isSigned])
        [request setValue:[[CHMaster user] userAccessToken] forHTTPHeaderField:CH_DEF_MX_TOKEN];
    
	NSLog(@"[CH_REST] > request url: %@", url.relativeString);
	
    // parameters..
    if (parameters != nil) {
        NSString *urlParameters = @"app=ios";
        for (NSString *value in parameters) {
            urlParameters = [urlParameters stringByAppendingString:[NSString stringWithFormat:@"&%@=%@", value ,value]];
        }
		NSLog(@"[CH_REST] > request parameters: %@", urlParameters);
        [request setHTTPBody:[urlParameters dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        // error..
        if (connectionError) {
            NSLog(@"[CH_REST] conection error: %@", connectionError.description);
            [[CHMaster tools] dialogWithMessage:@"Não foi possível conectar-se à internet." title:@"Falha de conexão"];
            return;
        }
        // received data..
        if (data != nil) {
            NSError *e = nil;
			NSDictionary *JSON = [NSJSONSerialization
								  JSONObjectWithData: data
								  options: NSJSONReadingMutableContainers
								  error: &e];
            int wasSucceed = [[JSON objectForKey:@"succees"] intValue];
            if (wasSucceed > 0) {
                NSLog(@"[CH_REST] succeed!");
                block(YES, JSON);
            }
            else {
                NSDictionary *dict = nil;
                NSString *message = [[JSON objectForKey:@"meta"] objectForKey:@"message"];
                if (message)
                    dict = @{@"message":message};
                block(NO, dict);
            }
        }
        else {
            NSLog(@"[CH_REST] didn't receive data");
        }
    }];
}

@end
