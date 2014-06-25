//
//  HSEventManager.m
//  HSM
//
//  Created by Felipe Ricieri on 25/06/14.
//  Copyright (c) 2014 ikomm Digital Solutions. All rights reserved.
//

#import "HSEventManager.h"

#define LOG_EKEVENT             @"ekEvent"

@interface HSEventManager ()
- (void) askForEKEventPermission;
- (BOOL) isAbleToSaveEKEvents;
- (NSInteger) minutesBetween:(NSDate*) firstDate and:(NSDate *) secondDate;
@end

@implementation HSEventManager

- (BOOL) isPanelistScheduled:(HSLecture *) lecture
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *logKey    = [NSString stringWithFormat:@"log_scheduled_%@", lecture.panelist.uniqueId];
    if ([[def objectForKey:logKey] isEqualToString:@"yes"])
        return YES;
    else
        return NO;
}
- (void) saveEKEventOnCalendar:(HSLecture *) lecture
{
    NSLog(@"[EKEVENT] ------");
    if ([self isAbleToSaveEKEvents])
    {
        NSLog(@"[EKEVENT] Start to save to iCal");
        // ...
        int interval = [self minutesBetween:lecture.hourStart and:lecture.hourEnd] * 60; // transform minutes into hours..
        EKEventStore *eventStore    = [[EKEventStore alloc] init];
        EKEvent *ekEvent            = [EKEvent eventWithEventStore:eventStore];
        EKAlarm *alarm              = [EKAlarm alarmWithRelativeOffset:60.0f * -20.0f]; // 20 min
        
        NSString *eventTit  = [NSString stringWithFormat:@"HSM: %@ (Palestra)", lecture.panelist.name];
        
        ekEvent.title       = eventTit;
        ekEvent.startDate   = lecture.date;
        ekEvent.endDate     = [[NSDate alloc] initWithTimeInterval:interval sinceDate:ekEvent.startDate];
        ekEvent.notes       = lecture.panelist.description;
        [ekEvent addAlarm:alarm];
        
        // save to ical..
        NSError *err;
        [ekEvent setCalendar:[eventStore defaultCalendarForNewEvents]];
        if ([eventStore saveEvent:ekEvent span:EKSpanThisEvent error:&err])
        {
            NSLog(@"[EKEVENT] Saved to iCal");
            // save to plist log..
            NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
            NSString *logKey = [NSString stringWithFormat:@"log_scheduled_%@", lecture.panelist.uniqueId];
            [def setObject:@"yes" forKey:logKey];
            [def synchronize];
        }
        else
            NSLog(@"[EKEVENT] NOT Saved to iCal");
    }
    else {
        // ask..
        NSLog(@"[EKEVENT] Ask before save to iCal");
        [self askForEKEventPermission];
    }
}

#pragma mark - Private Methods

- (void) askForEKEventPermission
{
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    [eventStore requestAccessToEntityType:EKEntityTypeEvent
                               completion:^(BOOL granted, NSError *error)
     {
         NSLog(@"[EKEVENT] -----");
         if (granted)
         {
             NSLog(@"[EKEVENT] Granted");
             NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
             [def setObject:@"yes" forKey:LOG_EKEVENT];
             [def synchronize];
         }
         // not allowed
         else {
             NSLog(@"[EKEVENT] Else Granted");
             [[HSMaster tools] dialogWithMessage:@"Para que o App HSM Inspiring Ideas possa salvar lembretes das palestras em seu calendário, é necessário que você libere esta permissão em seu iPhone."];
         }
     }];
}
- (BOOL) isAbleToSaveEKEvents
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    if([[def objectForKey:LOG_EKEVENT] isEqualToString:@"yes"])
        return YES;
    
    return NO;
}
- (NSInteger) minutesBetween:(NSDate *)firstDate and:(NSDate *)secondDate
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSUInteger unitFlags = NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *components = [gregorian components:unitFlags fromDate:firstDate toDate:secondDate options:0];
    
    return [components minute];
}

@end
