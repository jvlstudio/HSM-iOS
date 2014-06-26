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
{
    BOOL canLoadInBackground;
}

#pragma mark - Methods

- (void) loadInBackground:(BOOL) option
{
    canLoadInBackground = option;
}

// events..
- (void) events:(void(^)(BOOL succeed, NSDictionary *result))block
{
    NSString *stringURL = [NSString stringWithFormat:@"%@/events.php", HS_REST_SOURCE];
    // request..
    NSURL *url = [NSURL URLWithString:stringURL];
    [self sendRequestToURL:url method:kHTTPMethodGET parameters:nil completion:block];
}
// books
- (void) books:(void(^)(BOOL succeed, NSDictionary *result))block
{
    NSString *stringURL = [NSString stringWithFormat:@"%@/books.php", HS_REST_SOURCE];
    // request..
    NSURL *url = [NSURL URLWithString:stringURL];
    [self sendRequestToURL:url method:kHTTPMethodGET parameters:nil completion:block];
}
// magazines
- (void) magazines:(void(^)(BOOL succeed, NSDictionary *result))block
{
    NSString *stringURL = [NSString stringWithFormat:@"%@/magazines.php", HS_REST_SOURCE];
    // request..
    NSURL *url = [NSURL URLWithString:stringURL];
    [self sendRequestToURL:url method:kHTTPMethodGET parameters:nil completion:block];
}
// agenda (event)
- (void) agendaForEvent:(NSString *) eventId completion:(void(^)(BOOL succeed, NSDictionary *result))block
{
    NSString *stringURL = [NSString stringWithFormat:@"%@/agenda.php?event=%@", HS_REST_SOURCE, eventId];
    // request..
    NSURL *url = [NSURL URLWithString:stringURL];
    [self sendRequestToURL:url method:kHTTPMethodGET parameters:nil completion:block];
}
// panelists (event)
- (void) panelistsForEvent:(NSString *) eventId completion:(void(^)(BOOL succeed, NSDictionary *result))block
{
    NSString *stringURL = [NSString stringWithFormat:@"%@/panelists.php?event=%@", HS_REST_SOURCE, eventId];
    // request..
    NSURL *url = [NSURL URLWithString:stringURL];
    [self sendRequestToURL:url method:kHTTPMethodGET parameters:nil completion:block];
}
// passes (event)
- (void) passesForEvent:(NSString *) eventId completion:(void(^)(BOOL succeed, NSDictionary *result))block
{
    NSString *stringURL = [NSString stringWithFormat:@"%@/passes.php?event=%@", HS_REST_SOURCE, eventId];
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
- (void) passesEmail:(NSString *) urlWithParameters completion:(void(^)(BOOL succeed, NSDictionary *result))block
{
    // request..
    NSURL *url = [NSURL URLWithString:urlWithParameters];
    [self sendRequestToURL:url method:kHTTPMethodGET parameters:nil completion:block];
}

#pragma mark - Private Methods

- (void) sendRequestToURL:(NSURL*) url method:(HTTPMethod) method parameters:(NSDictionary*) parameters completion:(void(^)(BOOL succeed, NSDictionary *result))block
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:120.0];
    [request setHTTPMethod:[HS_HTTP_METHODS objectAtIndex:method]];
    NSLog(@"[HS_REST] --------");
	NSLog(@"[HS_REST] request url: %@", url.relativeString);
	
    // parameters..
    if (parameters != nil) {
        NSString *urlParameters = @"app=ios";
        for (NSString *value in parameters) {
            urlParameters = [urlParameters stringByAppendingString:[NSString stringWithFormat:@"&%@=%@", value ,value]];
        }
		NSLog(@"[HS_REST] request parameters: %@", urlParameters);
        [request setHTTPBody:[urlParameters dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        // error..
        if (connectionError) {
            NSLog(@"[HS_REST] conection error: %@", connectionError.description);
            if(!canLoadInBackground)
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
            int wasSucceed = [[JSON objectForKey:@"success"] intValue];
            if (wasSucceed > 0) {
                NSLog(@"[HS_REST] succeed!");
                block(YES, JSON);
            }
            else {
                NSLog(@"[HS_REST] the JSON wasnt succeed");
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
