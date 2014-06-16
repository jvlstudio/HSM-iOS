//
//  HSAdManager.h
//  HSM
//
//  Created by Felipe Ricieri on 16/06/14.
//  Copyright (c) 2014 ikomm Digital Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSAd.h"

#pragma mark - Typedef

typedef enum HSAdType : NSInteger
{
    kTypeHome   = 0,
    kTypeFooter = 1
}
HSAdType;

#pragma mark - Interface

@interface HSAdManager : NSObject
{
    
}

#pragma mark - Methods

- (void) setAdClickedInBackground:(HSAd *) advertising;
- (void) setAdViewedInBackground:(HSAd *) advertising;

@end
