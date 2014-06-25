//
//  HSEventSingleViewController.h
//  HSM
//
//  Created by Felipe Ricieri on 16/06/14.
//  Copyright (c) 2014 ikomm Digital Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HSEvent.h"
#import "HSEventSingleContentView.h"
#import "HSEventSingleFooterView.h"
#import "HSEventSingleInfoView.h"
#import "HSEventSingleTextView.h"

@interface HSEventSingleViewController : UIViewController
{
    HSEvent *event;
    
    HSEventSingleContentView *contentView;
    HSEventSingleFooterView *footerView;
    HSEventSingleInfoView *infoView;
    HSEventSingleTextView *textView;
    
    IBOutlet UIScrollView *scroll;
}

@property (nonatomic, strong) HSEvent *event;

#pragma mark - IBActions

- (IBAction) pressBack:(UIBarButtonItem *)sender;

#pragma mark - Actions

- (void) pressInfo:(UIButton *) sender;
- (void) pressDates:(UIButton *) sender;

- (void) pressAgenda:(UIButton *) sender;
- (void) pressPanelists:(UIButton *) sender;
- (void) pressPasses:(UIButton *) sender;

@end
