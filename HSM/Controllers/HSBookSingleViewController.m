//
//  HSBookSingleViewController.m
//  HSM
//
//  Created by Felipe Ricieri on 16/06/14.
//  Copyright (c) 2014 ikomm Digital Solutions. All rights reserved.
//

#import "HSBookSingleViewController.h"

@interface HSBookSingleViewController ()
- (void) setConfiguration;
@end

@implementation HSBookSingleViewController

@synthesize book;

#pragma mark - Controller Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setConfiguration];
}

#pragma mark - Methods

- (void) setConfiguration
{
    // infos
    [labTitle setText:book.title];
    [labSubtitle setText:book.subtitle];
    [labTitle setFont:[UIFont fontWithName:FONT_REGULAR size:labTitle.font.pointSize]];
    [labSubtitle setFont:[UIFont fontWithName:FONT_REGULAR size:labSubtitle.font.pointSize]];
    
    [labTitle alignBottom];
    [labSubtitle alignTop];
    
    [labPrice setText:[NSString stringWithFormat:@"R$ %@", book.price]];
    [labAuthor setText:book.authorName];
    //[labEspecDimensions setText:[[self dictionary] objectForKey:KEY_DIMENSIONS]];
    //[labEspecPages setText:[[self dictionary] objectForKey:KEY_PAGES]];
    //[labEspecCodebarBook setText:[[self dictionary] objectForKey:KEY_CODEBAR_BOOK]];
    //[labEspecCodebarEBook setText:[[self dictionary] objectForKey:KEY_CODEBAR_EBOOK]];
    [tvSinopse setText:book.description];
    [tvAuthor setText:book.authorDescription];
    
    NSString *strImg    = [NSString stringWithFormat:@"%@.png", book.slug];
    [imgPicture setImage:[UIImage imageNamed:strImg]];
    
    // scroll
    [scroll setContentSize:CGSizeMake(WINDOW_WIDTH, 500)];
    
    [scrollSub setContentSize:CGSizeMake(WINDOW_WIDTH*3, scrollSub.frame.size.height)];
    [scrollSub addSubview:vDescription];
    [scrollSub addSubview:vEspec];
    [scrollSub addSubview:vAuthor];
}

#pragma mark -
#pragma mark IBActions

- (IBAction) pressBuy:(id)sender
{
    NSString *strURL = book.link;
    NSURL *url = [ [ NSURL alloc ] initWithString: strURL ];
    [[UIApplication sharedApplication] openURL:url];
}
- (IBAction) segmentChange:(UISegmentedControl*)sender
{
    switch (sender.selectedSegmentIndex)
    {
        case 0:
        {
            [UIView animateWithDuration:0.5f animations:^{
                [scrollSub setContentOffset:CGPointMake(0, 0)];
            }];
        }
            break;
        case 1:
        {
            [UIView animateWithDuration:0.5f animations:^{
                [scrollSub setContentOffset:CGPointMake(WINDOW_WIDTH, 0)];
            }];
        }
            break;
        case 2:
        {
            [UIView animateWithDuration:0.5f animations:^{
                [scrollSub setContentOffset:CGPointMake((WINDOW_WIDTH*2), 0)];
            }];
        }
            break;
    }
}

#pragma mark - Scroll Methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == scrollSub)
    {
        CGPoint offset = scrollView.contentOffset;
        if (offset.x == 0)
        {
            [segment setSelectedSegmentIndex:0];
        }
        if (offset.x == WINDOW_WIDTH)
        {
            [segment setSelectedSegmentIndex:1];
        }
        if (offset.x == (WINDOW_WIDTH*2))
        {
            [segment setSelectedSegmentIndex:2];
        }
    }
}

@end
