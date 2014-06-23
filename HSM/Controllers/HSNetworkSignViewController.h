//
//  HSNetworkSignViewController.h
//  HSM
//
//  Created by Felipe Ricieri on 23/06/14.
//  Copyright (c) 2014 ikomm Digital Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSNetworkSignViewController : UIViewController
<UITextFieldDelegate, UIScrollViewDelegate, UIActionSheetDelegate>
{
    IBOutlet UIScrollView *scroll;
    IBOutlet UIView *contentView;
    IBOutlet UIButton *butCreate;
    
    IBOutlet UITextField *tfName;
    IBOutlet UITextField *tfEmail;
    IBOutlet UITextField *tfPhone;
    IBOutlet UITextField *tfMobile;
    IBOutlet UITextField *tfCompany;
    IBOutlet UITextField *tfRole;
    IBOutlet UITextField *tfWebsite;
    
    UIActionSheet *actsheet;
}

#pragma mark - IBActions

- (IBAction) doneEditing:(id)sender;
- (IBAction) pressCreate:(id)sender;

@end
