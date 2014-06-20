//
//  HSHomeViewController.h
//  HSM
//
//  Created by Felipe Ricieri on 16/06/14.
//  Copyright (c) 2014 ikomm Digital Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - Typedef

typedef enum HSTabBarOptions : NSInteger
{
    kTabHome        = 0,
    kTabEvents      = 1,
    kTabNetwork     = 2,
    kTabBooks       = 3,
    kTabMore        = 4
}
HSTabBarOptions;

#pragma mark - Interface

@interface HSHomeViewController : UIViewController <UIScrollViewDelegate>
{
    IBOutlet UIScrollView *scroll;
    IBOutlet UIScrollView *scrollDisplay;
    IBOutlet UIPageControl *pageControl;
}

#pragma mark -
#pragma mark IBActions

- (IBAction) pressExpo:(UIButton*)sender;
- (IBAction) pressEducation:(UIButton*)sender;
- (IBAction) pressTV:(UIButton*)sender;
- (IBAction) pressIssues:(UIButton*)sender;
- (IBAction) pressBooks:(UIButton*)sender;

@end
