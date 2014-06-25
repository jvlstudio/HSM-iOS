//
//  HSEventManager.h
//  HSM
//
//  Created by Felipe Ricieri on 25/06/14.
//  Copyright (c) 2014 ikomm Digital Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Accounts/Accounts.h>
#import <EventKit/EventKit.h>

#import "HSLecture.h"

@interface HSEventManager : NSObject

#pragma mark - Methods

- (BOOL) isPanelistScheduled:(HSLecture *) lecture;
- (void) saveEKEventOnCalendar:(HSLecture *) lecture;

@end
