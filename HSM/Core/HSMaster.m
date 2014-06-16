//
//  HSMaster.m
//  HSM
//
//  Created by Felipe Ricieri on 16/06/14.
//  Copyright (c) 2014 ikomm Digital Solutions. All rights reserved.
//

#import "HSMaster.h"

@implementation HSMaster

@synthesize stringConverter;
@synthesize humamFormatter;

#pragma mark -
#pragma mark Shared Singleton
+ (HSMaster *) core {
    static HSMaster *singleton;
    @synchronized(self) {
        if (!singleton){
            singleton = [[HSMaster alloc] init];
			singleton.stringConverter = [[NSDateFormatter alloc] init];
			singleton.humamFormatter = [[NSDateFormatter alloc] init];
			// Setup
			[singleton.stringConverter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
			[singleton.humamFormatter setDateFormat:@"dd/MM"];
        }
        return singleton;
    }
}
+ (HSRestClient *) rest {
	static HSRestClient* rest;
	@synchronized(self){
		if(!rest){
			rest = [HSRestClient new];
		}
		return rest;
	}
}
+ (HSTools *) tools {
	static HSTools* tools;
	@synchronized(self){
		if(!tools){
			tools = [HSTools new];
		}
		return tools;
	}
}
+ (HSAnalytics *) analytics {
	static HSAnalytics* analytics;
	@synchronized(self){
		if(!analytics){
			analytics = [HSAnalytics new];
		}
		return analytics;
	}
}
+ (HSAdManager *) ads {
	static HSAdManager* ad;
	@synchronized(self){
		if(!ad){
			ad = [HSAdManager new];
		}
		return ad;
	}
}

@end
