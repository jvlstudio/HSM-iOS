//
//  HSHomeViewController.m
//  HSM
//
//  Created by Felipe Ricieri on 16/06/14.
//  Copyright (c) 2014 ikomm Digital Solutions. All rights reserved.
//

#import "HSHomeViewController.h"
#import "HSAdBannerExpand.h"

#pragma mark - Interface

@interface HSHomeViewController ()
- (void) setDisplay;
@end

#pragma mark - Implementation

@implementation HSHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // ...
    [scr setContentSize:CGSizeMake(v.frame.size.width, v.frame.size.height)];
    [scr addSubview:v];
    
    //[scrDisplay addSubview:butExpo];
    
    // ...
    [pageControl setNumberOfPages:0];
	[tools requestUpdateFrom:URL_ADS success:^{
		// ...
		NSDictionary *data = [[tools JSONData] objectForKey:KEY_DATA];
        [tools propertyListWrite:data forFileName:PLIST_ADS];
        [self setDisplay];
	} fail:^{
		// ...
	}];
}

- (void) setDisplay
{
    NSInteger n = ([adManager hasAdWithCategory:kAdBannerHome] ? 1 : 0);
    [pageControl setNumberOfPages:1+n];
    [pageControl setCurrentPage:0];
    [pageControl setTintColor:COLOR_TITLE];
    
    NSInteger w = ([adManager hasAdWithCategory:kAdBannerHome] ? WINDOW_WIDTH : 0);
    [scrDisplay setContentSize:CGSizeMake(WINDOW_WIDTH+w, 200)];
    
    // ...
    [adManager addAdTo:scr type:kAdBannerExpand];
    [adManager addAdTo:scrDisplay type:kAdBannerHome];
}

#pragma mark - IBActions

- (IBAction) pressExpo:(UIButton*)sender
{
    
}
- (IBAction) pressEducation:(UIButton*)sender
{
    //[tools dialogWithMessage:@"Este conteúdo estará disponível em breve." cancelButton:@"OK" title:@"Conteúdo Indisponível"];
}
- (IBAction) pressTV:(UIButton*)sender
{
    NSString *strURL = @"http://www.youtube.com/watch?v=ZHolmn4LBzg";
    NSURL *url = [ [ NSURL alloc ] initWithString: strURL ];
    [[UIApplication sharedApplication] openURL:url];
}
- (IBAction) pressIssues:(UIButton*)sender
{
    
}
- (IBAction) pressBooks:(UIButton*)sender
{
    
}

#pragma mark - ScrollView Delegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView == scrDisplay) {
        float position = scrollView.contentOffset.x/WINDOW_WIDTH;
        [pageControl setCurrentPage:position];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == scrDisplay) {
        float position = scrollView.contentOffset.x/WINDOW_WIDTH;
        [pageControl setCurrentPage:position];
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    for (UIView *subv in [[self view] subviews]) {
        if ([subv isKindOfClass:[HSMAdBannerExpand class]]) {
            HSMAdBannerExpand *ban = (HSMAdBannerExpand*)subv;
            if ([ban isExpanded]) {
                [ban performReduce];
            }
        }
    }
}

@end
