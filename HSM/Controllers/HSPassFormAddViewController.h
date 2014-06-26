//
//  HSPassFormAddViewController.h
//  HSM
//
//  Created by Felipe Ricieri on 26/06/14.
//  Copyright (c) 2014 ikomm Digital Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSPassFormAddViewController : UIViewController
<UITextFieldDelegate, UIScrollViewDelegate>
{
    NSIndexPath *indexPath;
    
    IBOutlet UIScrollView *scr;
    IBOutlet UIView *v;
    
    IBOutlet UILabel *labText;
    IBOutlet UITextField *tfName;
    IBOutlet UITextField *tfEmail;
    IBOutlet UITextField *tfCPF;
    IBOutlet UITextField *tfCompany;
    IBOutlet UITextField *tfRole;
    IBOutlet UIButton *but;
}

@property (nonatomic, strong) NSIndexPath *indexPath;

#pragma mark - IBActions

- (IBAction) pressConfirm:(id)sender;

@end
