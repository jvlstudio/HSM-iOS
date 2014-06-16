//
//  HSEventManager.h
//  HSM
//
//  Created by Felipe Ricieri on 16/06/14.
//  Copyright (c) 2014 ikomm Digital Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSEvent.h"

@interface HSEventManager : NSObject

#pragma mark - Methods

- (void) saveEvents:(NSArray *) events;
- (NSArray *) events;
- (HSEvent *) eventForId:(NSString *) eventId;

@end
