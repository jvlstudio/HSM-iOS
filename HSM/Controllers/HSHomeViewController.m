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
- (void) setConfigurations;
@end

#pragma mark - Implementation

@implementation HSHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setConfigurations];
}

#pragma mark - Methods

- (void) setConfigurations
{
    // scroll
    [scroll setContentSize:CGSizeMake(WINDOW_WIDTH, 700)];
    // scroll display
    [scrollDisplay setPagingEnabled:YES];
    // page control
    [pageControl setNumberOfPages:1];
    [pageControl setCurrentPage:0];
    [pageControl setTintColor:COLOR_TITLE];
}

#pragma mark - IBActions

- (IBAction) pressExpo:(UIButton*)sender
{
    [[self tabBarController] setSelectedIndex:kTabEvents];
}
- (IBAction) pressEducation:(UIButton*)sender
{
    [[HSMaster tools] dialogWithMessage:@"Este conteúdo estará disponível em breve." title:@"Conteúdo Indisponível"];
}
- (IBAction) pressTV:(UIButton*)sender
{
    NSString *strURL = @"http://www.youtube.com/watch?v=ZHolmn4LBzg";
    NSURL *url = [ [ NSURL alloc ] initWithString: strURL ];
    [[UIApplication sharedApplication] openURL:url];
}
- (IBAction) pressIssues:(UIButton*)sender
{
    [[self tabBarController] setSelectedIndex:kTabMore];
}
- (IBAction) pressBooks:(UIButton*)sender
{
    [[self tabBarController] setSelectedIndex:kTabBooks];
}

#pragma mark - ScrollView Delegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView == scrollDisplay) {
        float position = scrollView.contentOffset.x/WINDOW_WIDTH;
        [pageControl setCurrentPage:position];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == scrollDisplay) {
        float position = scrollView.contentOffset.x/WINDOW_WIDTH;
        [pageControl setCurrentPage:position];
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    /*
    for (UIView *subv in [[self view] subviews]) {
        if ([subv isKindOfClass:[HSMAdBannerExpand class]]) {
            HSMAdBannerExpand *ban = (HSMAdBannerExpand*)subv;
            if ([ban isExpanded]) {
                [ban performReduce];
            }
        }
    }*/
}

@end
