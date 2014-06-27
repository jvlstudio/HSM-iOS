//
//  HSPassDoneViewController.h
//  HSM
//
//  Created by Felipe Ricieri on 16/06/14.
//  Copyright (c) 2014 ikomm Digital Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSPassDoneViewController : UIViewController
{
    IBOutlet UIScrollView *scroll;
    IBOutlet UIView *contentView;
    IBOutlet UIButton *button;
}

#pragma mark - IBActions

- (IBAction) pressButton:(UIButton *)sender;

@end
