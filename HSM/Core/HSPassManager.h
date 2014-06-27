//
//  HSPassManager.h
//  HSM
//
//  Created by Felipe Ricieri on 27/06/14.
//  Copyright (c) 2014 ikomm Digital Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSPassManager : NSObject

- (void) recordValue: (NSString*) value forKey:(NSString*) key atIndexPath:(NSIndexPath*) ip withColor:(HSPassColor) color;
- (void) recordParticipant:(NSMutableDictionary*) dict atIndexPath:(NSIndexPath*) ip withColor:(HSPassColor) color;
- (NSDictionary*) rowAtIndexPath:(NSIndexPath*) ip withColor:(HSPassColor) color;
- (BOOL) removeParticipantAtIndexPath:(NSIndexPath*) ip withColor:(HSPassColor) color;

@end
