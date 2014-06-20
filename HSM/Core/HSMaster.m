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
+ (HSAnalytics *) analytics {
	static HSAnalytics* analytics;
	@synchronized(self){
		if(!analytics){
			analytics = [HSAnalytics new];
		}
		return analytics;
	}
}
+ (HSRestClient *) rest {
	static HSRestClient* rest;
	@synchronized(self){
		if(!rest){
			rest = [HSRestClient new];
            [rest loadInBackground:NO];
		}
		return rest;
	}
}
+ (HSLocalClient *) local {
	static HSLocalClient* local;
	@synchronized(self){
		if(!local){
			local = [HSLocalClient new];
		}
		return local;
	}
}
+ (HSNetworkManager *) network {
	static HSNetworkManager* network;
	@synchronized(self){
		if(!network){
			network = [HSNetworkManager new];
		}
		return network;
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

@end
