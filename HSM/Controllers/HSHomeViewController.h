//
//  HSHomeViewController.h
//  HSM
//
//  Created by Felipe Ricieri on 16/06/14.
//  Copyright (c) 2014 ikomm Digital Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSHomeViewController : UIViewController <UIScrollViewDelegate>
{
    IBOutlet UIScrollView *scr;
    IBOutlet UIScrollView *scrDisplay;
    IBOutlet UIPageControl *pageControl;
    IBOutlet UIView *v;
    
    IBOutlet UIButton *butExpo;
    IBOutlet UIButton *butEducation;
    IBOutlet UIButton *butTV;
    IBOutlet UIButton *butIssues;
    IBOutlet UIButton *butBooks;
}

#pragma mark -
#pragma mark IBActions

- (IBAction) pressExpo:(UIButton*)sender;
- (IBAction) pressEducation:(UIButton*)sender;
- (IBAction) pressTV:(UIButton*)sender;
- (IBAction) pressIssues:(UIButton*)sender;
- (IBAction) pressBooks:(UIButton*)sender;

@end
