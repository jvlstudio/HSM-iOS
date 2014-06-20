//
//  HSNetworkSingleViewController.h
//  HSM
//
//  Created by Felipe Ricieri on 16/06/14.
//  Copyright (c) 2014 ikomm Digital Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "HSContact.h"

@interface HSNetworkSingleViewController : UIViewController <MFMailComposeViewControllerDelegate>
{
    HSContact *contact;
    
    IBOutlet UILabel *labName;
    IBOutlet UILabel *labName2;
    IBOutlet UILabel *labEmail;
    IBOutlet UILabel *labCompany;
    IBOutlet UILabel *labRole;
    IBOutlet UILabel *labPhone;
    IBOutlet UILabel *labMobile;
    IBOutlet UIView *blackView;
    
    IBOutlet UIImageView *imgColor;
    IBOutlet UIImageView *imgQRCode;
    IBOutlet UIImageView *imgZoom;
    
    IBOutlet UIButton *butAddContact;
    IBOutlet UIButton *butSendEmail;
    IBOutlet UIButton *butBlack;
}

@property (nonatomic, strong) HSContact *contact;

#pragma mark - IBActions

- (IBAction) pressAddContact:(UIButton *)sender;
- (IBAction) pressSendEmail:(UIButton *)sender;
- (IBAction) pressBlack:(UIButton *)sender;

@end
