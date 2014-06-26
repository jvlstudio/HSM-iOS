//
//  HSPanelistSingleViewController.h
//  HSM
//
//  Created by Felipe Ricieri on 16/06/14.
//  Copyright (c) 2014 ikomm Digital Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSLecture.h"

@interface HSPanelistSingleViewController : UIViewController
{
    HSLecture *lecture;
    HSPanelist *panelist;
    
    UITextView *textDescription;
    UITextView *textTheme;
    UILabel *labTheme;
    
    IBOutlet UIScrollView *scroll;
    IBOutlet UIView *headerView;
    IBOutlet UIImageView *imgPicture;
    IBOutlet UILabel *labName;
    IBOutlet UILabel *labLecture;
    IBOutlet UILabel *labDate;
    IBOutlet UILabel *labHour;
    IBOutlet UIButton *butSchedule;
}

@property (nonatomic, strong) HSLecture *lecture;
@property (nonatomic, strong) HSPanelist *panelist;

#pragma mark - Actions

- (void) pressBack:(UIBarButtonItem *) sender;

#pragma mark - IBActions

- (IBAction) pressSchedule:(UIButton *)sender;

@end
