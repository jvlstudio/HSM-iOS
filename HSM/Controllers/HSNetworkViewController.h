//
//  HSNetworkViewController.h
//  HSM
//
//  Created by Felipe Ricieri on 16/06/14.
//  Copyright (c) 2014 ikomm Digital Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"
#import "HSContact.h"

@interface HSNetworkViewController : UITableViewController <ZBarReaderDelegate>
{
    NSArray *rows;
    HSContact *selfContact;
    HSContact *selectedContact;
    
    NSString *zBarSymbolData;
    ZBarReaderViewController *zBarReader;
    
    IBOutlet UIView *selfView;
    IBOutlet UIImageView *selfColor;
    IBOutlet UILabel *selfTitle;
    IBOutlet UILabel *selfSubtitle;
    
    IBOutlet UIView *createView;
    IBOutlet UIButton *butCreate;
    IBOutlet UIButton *butSelf;
}

#pragma mark - IBActions

- (IBAction) pressCreate:(UIButton *)sender;
- (IBAction) pressSelf:(UIButton *)sender;
- (IBAction) pressScan:(UIBarButtonItem *)sender;

@end
