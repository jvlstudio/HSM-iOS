//
//  HSPassFormAddViewController.h
//  HSM
//
//  Created by Felipe Ricieri on 26/06/14.
//  Copyright (c) 2014 ikomm Digital Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSPass.h"

@interface HSPassFormAddViewController : UIViewController
<UITextFieldDelegate, UIScrollViewDelegate>
{
    HSPass *pass;
    NSIndexPath *indexPath;
    
    IBOutlet UIScrollView *scroll;
    IBOutlet UIView *contentView;
    
    IBOutlet UILabel *labText;
    IBOutlet UITextField *tfName;
    IBOutlet UITextField *tfEmail;
    IBOutlet UITextField *tfCPF;
    IBOutlet UITextField *tfCompany;
    IBOutlet UITextField *tfRole;
    IBOutlet UIButton *button;
}

@property (nonatomic, strong) HSPass *pass;
@property (nonatomic, strong) NSIndexPath *indexPath;

#pragma mark - IBActions

- (IBAction) pressConfirm:(UIButton *)sender;
- (IBAction) pressBack:(UIBarButtonItem *)sender;
- (IBAction) textFieldDidEndOnExit:(UITextField *) sender;

@end
