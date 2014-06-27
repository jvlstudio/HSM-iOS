//
//  HSPassDoneViewController.m
//  HSM
//
//  Created by Felipe Ricieri on 16/06/14.
//  Copyright (c) 2014 ikomm Digital Solutions. All rights reserved.
//

#import "HSPassDoneViewController.h"

@interface HSPassDoneViewController ()

@end

@implementation HSPassDoneViewController

#pragma mark Controller Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    //
    self.navigationItem.hidesBackButton = YES;
    [scroll setContentSize:CGSizeMake(contentView.frame.size.width, contentView.frame.size.height)];
}

#pragma mark -
#pragma mark IBActions

- (IBAction) pressButton:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
