//
//  HSEventSingleViewController.m
//  HSM
//
//  Created by Felipe Ricieri on 16/06/14.
//  Copyright (c) 2014 ikomm Digital Solutions. All rights reserved.
//

#import "HSPanelistsViewController.h"
#import "HSAgendaViewController.h"
#import "HSPassesViewController.h"

#import "HSEventSingleViewController.h"

#define PADDING_BOTTOM          20
#define DELAY_ANIMATION         0.4f

#define V_HEIGHT                339 //411
#define ELASTIC_HEIGHT          0
#define ELASTIC_SHOWN_HEIGHT    334
#define DATES_HEIGHT            209
#define BOTTOM_Y                V_HEIGHT
#define NEGATIVE_INDEX          190

#pragma mark - Typedef

typedef enum HSEventInfoType : NSInteger
{
    kTypeNone   = 0,
    kTypeDates  = 1,
    kTypeInfo   = 2
}
HSEventInfoType;

#pragma mark - Interface

@interface HSEventSingleViewController ()
- (void) updateRootScrollFrame;
- (void) eventExpandForType:(HSEventInfoType) type;
- (void) eventRetrive;
@end

#pragma mark - Implementation

@implementation HSEventSingleViewController
{
    HSEventInfoType contentOpen;
}

@synthesize event;

#pragma mark Controller Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:event.name];
    
    // ..
    contentOpen = kTypeNone;
    
    contentView.imgCover.hidden = YES;
    
    // event single views
    contentView = (HSEventSingleContentView *)[[HSMaster core] resourceAtIndex:kResourceEventSingleContent];
    footerView  = (HSEventSingleFooterView *)[[HSMaster core] resourceAtIndex:kResourceEventSingleFooter];
    infoView    = (HSEventSingleInfoView *)[[HSMaster core] resourceAtIndex:kResourceEventSingleInfo];
    textView    = (HSEventSingleTextView *)[[HSMaster core] resourceAtIndex:kResourceEventSingleText];
    
    // configurate ..
    [contentView.butContent addTarget:self action:@selector(pressInfo:) forControlEvents:UIControlEventTouchUpInside];
    [contentView.butDates addTarget:self action:@selector(pressDates:) forControlEvents:UIControlEventTouchUpInside];
    [footerView.butAgenda addTarget:self action:@selector(pressAgenda:) forControlEvents:UIControlEventTouchUpInside];
    [footerView.butPanelists addTarget:self action:@selector(pressPanelists:) forControlEvents:UIControlEventTouchUpInside];
    [footerView.butPasses addTarget:self action:@selector(pressPasses:) forControlEvents:UIControlEventTouchUpInside];
    
    if (![[HSMaster local] eventDidHappen:event])
    {
        [footerView.butPasses setEnabled:NO];
        [footerView.butPasses setAlpha:0.5];
    }
    
    [contentView.imgCover setImageWithURL:[NSURL URLWithString:event.pictureSingle]];
    [contentView.elasticView setBackgroundColor:[UIColor colorWithRed:35.0/255.0 green:34.0/255.0 blue:46.0/255.0 alpha:1]];
    
    [scroll addSubview:contentView];
    [scroll addSubview:footerView];
    
    CGRect rect1        = footerView.frame;
    rect1.origin.y      = contentView.frame.size.height + contentView.frame.origin.y;
    [footerView setFrame:rect1];
    
    // ..
    CGRect rect2        = contentView.elasticView.frame;
    rect2.size.height   = 1;
    rect2.origin.y      = contentView.frame.size.height + contentView.frame.origin.y-5;
    [contentView.elasticView setFrame:rect2];
    
    // ..
    CGRect rect3        = textView.frame;
    rect3.origin.x      = 10;
    rect3.origin.y      = 10;
    rect3.size.width    = contentView.elasticView.frame.size.width-20;
    rect3.size.height   = 0;
    [textView setFrame:rect3];
    [textView setAlpha:0];
    
    // ..
    CGRect rect4        = infoView.frame;
    rect4.origin.x      = 10;
    rect4.origin.y      = 10;
    rect4.size.width    = contentView.elasticView.frame.size.width-20;
    rect4.size.height   = 0;
    [infoView setFrame:rect4];
    [infoView setAlpha:0];
    
    // ..
    [textView setText:event.largeDescription];
    [infoView.labDates setText:event.datePretty];
    [infoView.labHours setText:event.hours];
    [infoView.labLocale setText:event.local];
    
    [infoView.labDates setFont:[UIFont fontWithName:FONT_REGULAR size:16.0]];
    [infoView.labHours setFont:[UIFont fontWithName:FONT_REGULAR size:16.0]];
    [infoView.labLocale setFont:[UIFont fontWithName:FONT_REGULAR size:16.0]];
    
    [contentView.elasticView addSubview:textView];
    [contentView.elasticView addSubview:infoView];
    
    // ..
    [self updateRootScrollFrame];
    
    [[footerView.butAgenda titleLabel] setFont:[UIFont fontWithName:FONT_REGULAR size:17.0]];
    [[footerView.butPanelists titleLabel] setFont:[UIFont fontWithName:FONT_REGULAR size:17.0]];
    [[footerView.butPasses titleLabel] setFont:[UIFont fontWithName:FONT_REGULAR size:17.0]];
}

#pragma mark - IBActions

- (IBAction) pressBack:(UIBarButtonItem *)sender
{
    [[self navigationController] popViewControllerAnimated:YES];
}

#pragma mark - Actions

- (void) pressInfo:(UIButton *) sender
{
    [contentView.imgBottom setImage:[UIImage imageNamed:@"events_single_card_bottom_about.png"]];
    if(contentOpen == kTypeInfo)
    {
        [self eventRetrive];
        [contentView.imgBottom setImage:[UIImage imageNamed:@"events_single_card_bottom.png"]];
        return;
    }
    
    [self eventExpandForType:kTypeInfo];
}
- (void) pressDates:(UIButton *) sender
{
    [contentView.imgBottom setImage:[UIImage imageNamed:@"events_single_card_bottom_infos.png"]];
    if(contentOpen == kTypeDates)
    {
        [self eventRetrive];
        [contentView.imgBottom setImage:[UIImage imageNamed:@"events_single_card_bottom.png"]];
        return;
    }
    
    [self eventExpandForType:kTypeDates];
}

- (void) pressAgenda:(UIButton *) sender
{
    [self performSegueWithIdentifier:@"segue_agenda" sender:self];
}
- (void) pressPanelists:(UIButton *) sender
{
    UIStoryboard *panelistSB = [UIStoryboard storyboardWithName:@"Panelists" bundle:nil];
    HSPanelistsViewController *vc = (HSPanelistsViewController *)[panelistSB instantiateInitialViewController];
    vc.event = event;
    [[self navigationController] pushViewController:vc animated:YES];
}
- (void) pressPasses:(UIButton *) sender
{
    UIStoryboard *panelistSB = [UIStoryboard storyboardWithName:@"Pass" bundle:nil];
    UINavigationController *n = (UINavigationController *)[panelistSB instantiateInitialViewController];
    HSPassesViewController *vc = (HSPassesViewController *)[[n viewControllers] objectAtIndex:0];
    vc.event = event;
    [self presentViewController:n animated:YES completion:nil];
}

#pragma mark - Private Methods

- (void) updateRootScrollFrame
{
    float bottomHeight = footerView.frame.size.height;
    [scroll setContentSize:CGSizeMake(contentView.frame.size.width, contentView.frame.size.height + bottomHeight)];
}
- (void) eventExpandForType:(HSEventInfoType)type
{
    // always start from the all original points.
    NSInteger height = 0;
    
    // ..
    switch (type)
    {
        case kTypeNone:
            // ...
            break;
            
        case kTypeDates:
        {
            height = DATES_HEIGHT;
            [UIView animateWithDuration:DELAY_ANIMATION animations:^{
                // content
                CGRect rect1        = contentView.elasticView.frame;
                rect1.size.height   = height + PADDING_BOTTOM;
                [contentView.elasticView setFrame:rect1];
                // footer
                CGRect rect2        = footerView.frame;
                rect2.origin.y      = height + PADDING_BOTTOM + BOTTOM_Y;
                [footerView setFrame:rect2];
                // dates
                CGRect rect3        = infoView.frame;
                rect3.size.height   = height;
                [infoView setFrame:rect3];
                [infoView setAlpha:1];
                // info
                [textView setAlpha:0];
                // ..
                CGRect rect5        = contentView.frame;
                rect5.size.height   = height + PADDING_BOTTOM + V_HEIGHT;
                [contentView setFrame:rect5];
                // ..
                [self updateRootScrollFrame];
                contentOpen = kTypeDates;
            }];
        }
            break;
            
        case kTypeInfo:
        {
            height = textView.contentSize.height;
            [UIView animateWithDuration:DELAY_ANIMATION animations:^{
                // content
                CGRect rect1        = contentView.elasticView.frame;
                rect1.origin.y      = ELASTIC_SHOWN_HEIGHT;
                rect1.size.height   = height + PADDING_BOTTOM + ELASTIC_SHOWN_HEIGHT;
                [contentView.elasticView setFrame:rect1];
                // footer
                CGRect rect2        = footerView.frame;
                rect2.origin.y      = height + PADDING_BOTTOM + BOTTOM_Y;
                [footerView setFrame:rect2];
                // info
                [infoView setAlpha:0];
                // text
                CGRect rect3        = textView.frame;
                rect3.size.height   = height;
                [textView setFrame:rect3];
                [textView setAlpha:1];
                //
                CGRect rect5        = contentView.frame;
                rect5.size.height   = height + PADDING_BOTTOM + V_HEIGHT;
                [contentView setFrame:rect5];
                //
                [self updateRootScrollFrame];
                contentOpen = kTypeInfo;
            }];
        }
            break;
    }
}
- (void) eventRetrive
{
    [UIView animateWithDuration:DELAY_ANIMATION animations:^{
        // elastic
        CGRect rect1        = contentView.elasticView.frame;
        rect1.size.height   = 0;
        [contentView.elasticView setFrame:rect1];
        // footer
        CGRect rect2        = footerView.frame;
        rect2.origin.y      = BOTTOM_Y;
        [footerView setFrame:rect2];
        // text
        CGRect rect3        = textView.frame;
        rect3.size.height   = 0;
        [textView setFrame:rect3];
        [textView setAlpha:0];
        // content
        CGRect rect4        = contentView.frame;
        rect4.size.height   = V_HEIGHT;
        [contentView setFrame:rect4];
        // ..
        [self updateRootScrollFrame];
    }];
    
    contentOpen = kTypeNone;
}

#pragma mark - Navigation

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    HSAgendaViewController *vc = (HSAgendaViewController *) segue.destinationViewController;
    vc.event = event;
}

@end
