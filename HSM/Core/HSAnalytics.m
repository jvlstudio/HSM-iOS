//
//  HSAnalytics.m
//  HSM
//
//  Created by Felipe Ricieri on 16/06/14.
//  Copyright (c) 2014 ikomm Digital Solutions. All rights reserved.
//

#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"
#import "HSAnalytics.h"

@implementation HSAnalytics

#pragma mark -
#pragma mark Declare Instance
- (void) declareInstance {
	static BOOL declared;
	if(!declared){
		[GAI sharedInstance].trackUncaughtExceptions = YES;
		[GAI sharedInstance].dispatchInterval = 20;
		[[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelError];
		// Initialize tracker.
		id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:HS_GOOGLEANALYTICS_KEY];
		[tracker send:[[[GAIDictionaryBuilder createEventWithCategory:@"UX" action:@"appstart" label:nil value:nil] set:@"start" forKey:kGAISessionControl] build]];
		declared = YES;
	}
}

#pragma mark -
#pragma mark Track view
- (void) trackViewWithName:(NSString*)name {
	// Track
	id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
	[tracker send:[[[GAIDictionaryBuilder createAppView]
                    set:name
                    forKey:kGAIScreenName]
                   build]];
}

@end
