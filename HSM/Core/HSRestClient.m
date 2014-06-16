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

// events..
- (void) events:(void(^)(BOOL succeed, NSDictionary *result))block
{
    NSString *stringURL = [NSString stringWithFormat:@"%@/events.php", HS_REST_SOURCE];
    // request..
    NSURL *url = [NSURL URLWithString:stringURL];
    [self sendRequestToURL:url method:kHTTPMethodGET parameters:nil completion:block];
}

// ads..
- (void) ads:(void(^)(BOOL succeed, NSDictionary *result))block
{
    NSString *stringURL = [NSString stringWithFormat:@"%@/ads.php", HS_REST_SOURCE];
    // request..
    NSURL *url = [NSURL URLWithString:stringURL];
    [self sendRequestToURL:url method:kHTTPMethodGET parameters:nil completion:block];
}
- (void) adClicked:(NSString *) adId completion:(void(^)(BOOL succeed, NSDictionary *result))block
{
    NSString *stringURL = [NSString stringWithFormat:@"%@/ads-link.php?id=%@", HS_REST_SOURCE, adId];
    // request..
    NSURL *url = [NSURL URLWithString:stringURL];
    [self sendRequestToURL:url method:kHTTPMethodGET parameters:nil completion:block];
}
- (void) adViewed:(NSString *) adId completion:(void(^)(BOOL succeed, NSDictionary *result))block
{
    NSString *stringURL = [NSString stringWithFormat:@"%@/ads-view.php?id=%@", HS_REST_SOURCE, adId];
    // request..
    NSURL *url = [NSURL URLWithString:stringURL];
    [self sendRequestToURL:url method:kHTTPMethodGET parameters:nil completion:block];
}

#pragma mark - Private Methods

- (void) sendRequestToURL:(NSURL*) url method:(HTTPMethod) method parameters:(NSDictionary*) parameters completion:(void(^)(BOOL succeed, NSDictionary *result))block
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:120.0];
    [request setHTTPMethod:[HS_HTTP_METHODS objectAtIndex:method]];
	NSLog(@"[HS_REST] > request url: %@", url.relativeString);
	
    // parameters..
    if (parameters != nil) {
        NSString *urlParameters = @"app=ios";
        for (NSString *value in parameters) {
            urlParameters = [urlParameters stringByAppendingString:[NSString stringWithFormat:@"&%@=%@", value ,value]];
        }
		NSLog(@"[HS_REST] > request parameters: %@", urlParameters);
        [request setHTTPBody:[urlParameters dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        // error..
        if (connectionError) {
            NSLog(@"[HS_REST] conection error: %@", connectionError.description);
            [[HSMaster tools] dialogWithMessage:@"Não foi possível conectar-se à internet." title:@"Falha de conexão"];
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
                NSLog(@"[HS_REST] succeed!");
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
            NSLog(@"[HS_REST] didn't receive data");
        }
    }];
}

@end
