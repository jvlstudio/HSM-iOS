//
//  HSPassFormViewController.h
//  HSM
//
//  Created by Felipe Ricieri on 16/06/14.
//  Copyright (c) 2014 ikomm Digital Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HSPass.h"
#import "HSPassPickerView.h"

#pragma mark - typedef

typedef enum HSPassCellType : NSUInteger
{
    kCellTypeSubtitle       = 0,
    kCellTypePicker         = 1,
    kCellTypePickerPayment  = 2,
    kCellTypeForm           = 3,
    kCellTypeAdd            = 4,
    kCellTypeEdit           = 5
}
HSPassCellType;

#pragma mark - Interface

@interface HSPassFormViewController : UITableViewController
<UIPickerViewDelegate, UIPickerViewDataSource>
{
    HSPass *pass;
    HSEvent *event;
    
    NSArray *plist;
    NSDictionary *passData;
    NSArray *passSections;
    NSArray *dates;
    
    HSPassPickerView *pvDates;
    HSPassPickerView *pvPayment;
    
    IBOutlet UIImageView *imgHeader;
    IBOutlet UIButton *butDone;
}

@property (nonatomic, strong) HSPass *pass;
@property (nonatomic, strong) HSEvent *event;

#pragma mark - IBActions

- (IBAction) pressConfirm:(UIButton *)sender;
- (IBAction) pressBack:(UIBarButtonItem *)sender;
- (void) pressDelete:(UIButton *)sender;

#pragma mark -
#pragma mark Record Methods

+ (void) recordValue: (NSString*) value forKey:(NSString*) key atIndexPath:(NSIndexPath*) ip;
+ (void) recordParticipant:(NSMutableDictionary*) dict atIndexPath:(NSIndexPath*) ip;
+ (NSDictionary*) rowAtIndexPath:(NSIndexPath*) ip;
+ (BOOL) removeParticipantAtIndexPath:(NSIndexPath*) ip;

- (void) saveFormDataToPropertyList;
- (void) sendPassEmailToHSM;

#pragma mark -
#pragma mark Table Methods

- (NSInteger) heightForCellType:(HSPassCellType) cellType;
- (NSString*) stringForPassColor:(HSPassColor) color;

#pragma mark -
#pragma mark Picker Methods

- (void) pickerShow:(UIPickerView*) picker;
- (void) pickerHide:(UIPickerView*) picker;

@end
