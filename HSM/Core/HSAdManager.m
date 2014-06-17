//
//  HSAdManager.m
//  HSM
//
//  Created by Felipe Ricieri on 16/06/14.
//  Copyright (c) 2014 ikomm Digital Solutions. All rights reserved.
//

#import "HSAdManager.h"

@implementation HSAdManager

#pragma mark - Methods

- (void) setAdClickedInBackground:(HSAd *) advertising
{
    [[HSMaster rest] adClicked:advertising.uniqueId completion:^(BOOL succeed, NSDictionary *result) {
        if (succeed) {
            if (result != nil) {
                // send request only
            }
        }
        else {
            [[HSMaster tools] dialogWithMessage:@"Atenção" title:[result objectForKey:@"message"]];
        }
    }];
}
- (void) setAdViewedInBackground:(HSAd *) advertising
{
    [[HSMaster rest] adViewed:advertising.uniqueId completion:^(BOOL succeed, NSDictionary *result) {
        if (succeed) {
            if (result != nil) {
                // send request only
            }
        }
        else {
            [[HSMaster tools] dialogWithMessage:@"Atenção" title:[result objectForKey:@"message"]];
        }
    }];
}

@end
