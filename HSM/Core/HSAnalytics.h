//
//  HSAnalytics.h
//  HSM
//
//  Created by Felipe Ricieri on 16/06/14.
//  Copyright (c) 2014 ikomm Digital Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSAnalytics : NSObject

// Init
- (void) declareInstance;

// Tracks
- (void) trackViewWithName:(NSString*)name;

@end
