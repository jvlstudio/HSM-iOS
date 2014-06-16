//
//  definitions.h
//  HSM
//
//  Created by Felipe Ricieri on 16/06/14.
//  Copyright (c) 2014 ikomm Digital Solutions. All rights reserved.
//

#ifndef HSM_definitions_h
#define HSM_definitions_h

// urls

#define	HS_URL						@"apps.ikomm.com.br/hsm5"
#define HS_REST_SOURCE				@"http://apps.ikomm.com.br/hsm5/rest"

// resources

#define HS_APP_NAME                  @"HSM"
#define HS_APP_RESOURCES             @"Resources"

// property list

#define HS_PLIST_EVENTS             @"HS-Events"
#define HS_PLIST_ADS                @"HS-Ads"

// third-part app ids

#define HS_PUBLIC_TOKEN				@"4fc5c9fda3dc404c65c9f6167a3da62c"
#define HS_FACEBOOK_ID              @"139301386281076"
#define HS_FACEBOOK_SECRET          @"9ceee311105aa8af80062dd97f49fded"
#define HS_FACEBOOK_PERMS           @[@"publish_stream", @"publish_actions", @"email", @"user_birthday"]
#define HS_PARSE_ID                 @"rTeFsHt9rmZVXtPu20QPONd1e3nldhpXB8XavuBY"
#define HS_PARSE_SECRET             @"j6XeRt7HSaA1lJ00yK7BknHBxfo7HWFV3DdTCVoZ"
#define HS_GAI_TRACKER              @"UA-51978835-1"
#define HS_CRASHLYTICS_KEY          @"48118b9b5992c16c30f272709e02fe01c05ee2d5"

// questions

#define IS_IPHONE5                  (([[UIScreen mainScreen] bounds].size.height-568) ? NO : YES)
#define IPHONE5_OFFSET              88
#define IPHONE5_COEF                IS_IPHONE5 ? ZERO : IPHONE5_OFFSET

#endif
