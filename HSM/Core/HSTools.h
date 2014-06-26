//
//  HSTools.h
//  HSM
//
//  Created by Felipe Ricieri on 16/06/14.
//  Copyright (c) 2014 ikomm Digital Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - Typedef

typedef enum AlertViewOption : NSUInteger
{
    kOptionNo   = 0,
    kOptionYes  = 1
}
AlertViewOption;

#pragma mark - Interface

@interface HSTools : NSObject <UIAlertViewDelegate>
{
	
}

@property (nonatomic, copy) void (^completionYes)(void);
@property (nonatomic, copy) void (^completionNo)(void);

#pragma mark - Methods

- (id)   propertyListRead:(NSString*) plistName;
- (BOOL) propertyListWrite:(id) content forFileName:(NSString*) fileName;

- (void) dialogWithMessage:(NSString*) message;
- (void) dialogWithMessage:(NSString*) message cancelButton:(NSString*) cancel;
- (void) dialogWithMessage:(NSString*) message cancelButton:(NSString*) cancel title:(NSString*) title;
- (void) dialogWithMessage:(NSString*) message title:(NSString*) title;
- (void) promptWithMessage:(NSString*) message title:(NSString*) title completionYes:(void(^)(void)) compYes completionNo:(void(^)(void)) compNo;
- (void) promptWithMessage:(NSString*) message completionYes:(void(^)(void)) compYes completionNo:(void(^)(void)) compNo;

- (BOOL) isValidEmail:(NSString*) str;
- (BOOL) isValidCPF:(NSString*) str;
- (BOOL) isValidCNPJ:(NSString*) str;

- (NSArray*) explode: (NSString*) string bySeparator:(NSString*)separator;

@end
