//
//  HSAppDelegate.m
//  HSM
//
//  Created by Felipe Ricieri on 16/06/14.
//  Copyright (c) 2014 ikomm Digital Solutions. All rights reserved.
//

#import <FacebookSDK/FacebookSDK.h>
#import <Parse/Parse.h>
#import <Crashlytics/Crashlytics.h>

#import "HSAppDelegate.h"

@implementation HSAppDelegate

#pragma mark -
#pragma mark Properties
@synthesize window;

#pragma mark -
#pragma mark Application Start
- (void) buildApplication {
}

#pragma mark - AppDelegate Methods

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Declare main operations
	[[HSMaster analytics] declareInstance];
    
	// crashlytics
	[Crashlytics startWithAPIKey:HS_CRASHLYTICS_KEY];
	
    // parse..
    [Parse setApplicationId:HS_PARSE_ID
                  clientKey:HS_PARSE_SECRET];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    // notifications..
	[application registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    [application cancelAllLocalNotifications];
    application.applicationIconBadgeNumber = 0;
	
	// Build application launch
    [self buildApplication];
    
    return YES;
}

#pragma mark -
#pragma mark Facebook Methods

/*
 - (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
 return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
 }*/
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [PFFacebookUtils handleOpenURL:url];
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [PFFacebookUtils handleOpenURL:url];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    
    [FBSession.activeSession handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
    [FBSession.activeSession close];
}

#pragma mark -
#pragma mark APNS Configuration

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSLog(@"Local Notification: App está ativo.");
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken
{
    [PFPush storeDeviceToken:devToken]; // Send parse the device token
    // Subscribe this user to the broadcast channel, ""
    [PFPush subscribeToChannelInBackground:@"" block:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"Successfully subscribed to the broadcast channel.");
        } else {
            NSLog(@"Failed to subscribe to the broadcast channel.");
        }
    }];
	
#if !TARGET_IPHONE_SIMULATOR
	// Prepare the Device Token for Registration (remove spaces and < >)
    NSString *token = [[[[devToken description]
                         stringByReplacingOccurrencesOfString:@"<"withString:@""]
                        stringByReplacingOccurrencesOfString:@">" withString:@""]
                       stringByReplacingOccurrencesOfString: @" " withString:@""];
	NSLog(@"device token: %@", devToken);
	NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
	[def setObject:token forKey:@"deviceToken"];
	[def synchronize];
#endif
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
#if !TARGET_IPHONE_SIMULATOR
	NSLog(@"Error in registration. Error: %@", error);
#endif
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [PFPush handlePush:userInfo];
}

@end
