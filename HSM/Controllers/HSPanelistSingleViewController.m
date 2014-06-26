//
//  HSPanelistSingleViewController.m
//  HSM
//
//  Created by Felipe Ricieri on 16/06/14.
//  Copyright (c) 2014 ikomm Digital Solutions. All rights reserved.
//

#import "HSPanelistSingleViewController.h"

@interface HSPanelistSingleViewController ()
- (void) setFramesForLecture;
- (void) setFramesForPanlist;
- (UITextView*) createTextView;
- (UILabel*) createLabelTitle;
- (NSString*) changeDateLabel:(NSString*) str;
- (NSString*) changeHourLabel:(NSString*) str;
- (NSString*) stringForHour;
- (void) disabledButton;
@end

@implementation HSPanelistSingleViewController

@synthesize lecture;
@synthesize panelist;

#pragma mark - Controller Methods

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    // navigation
    self.title = @"Palestrante";
    UIBarButtonItem *barbt = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btbar_back.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(pressBack:)];
    self.navigationItem.leftBarButtonItem = barbt;
    
    // has "panelist"
    if (panelist) {
        // ...
        textDescription = [self createTextView];
        
        [labTheme setText:lecture.title];
        [labTheme sizeToFit];
        
        // ...
        [labName setText:panelist.name];
        [labLecture setText:@"Palestrante"];
        [labDate setText:@"..."];
        [labHour setText:@"..."];
        [textDescription setText:panelist.description];
        
        [scroll addSubview:textDescription];
        
        [butSchedule setAlpha:0];
        [imgPicture setImage:[UIImage imageNamed:panelist.pictureURL]];
        
        // ...
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        NSString *logKey    = [NSString stringWithFormat:@"log_scheduled_%@", panelist.uniqueId];
        if ([[def objectForKey:logKey] isEqualToString:@"yes"])
            [self disabledButton];
    }
    
    // has "lecture"
    if (lecture) {
        panelist = lecture.panelist;
        
        // ...
        textDescription = [self createTextView];
        textTheme       = [self createTextView];
        labTheme        = [self createLabelTitle];
        
        [labTheme setText:lecture.themeTitle];
        [labTheme sizeToFit];
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"dd/MMM"];
        
        // ...
        [labName setText:panelist.name];
        [labLecture setText:lecture.themeTitle];
        [labDate setText:[df stringFromDate:lecture.date]];
        [labHour setText:[self stringForHour]];
        [textDescription setText:panelist.description];
        [textTheme setText:lecture.themeText];
        
        [scroll addSubview:textDescription];
        [scroll addSubview:labTheme];
        [scroll addSubview:textTheme];
        
        [butSchedule setAlpha:0];
        
        [imgPicture setImage:[UIImage imageNamed:panelist.pictureURL]];
        
        // ...
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        NSString *logKey    = [NSString stringWithFormat:@"log_scheduled_%@", panelist.uniqueId];
        if ([[def objectForKey:logKey] isEqualToString:@"yes"])
            [self disabledButton];
    }
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (panelist)
        [self setFramesForPanlist];
    if (lecture)
        [self setFramesForLecture];
}

#pragma mark - Actions

- (void) pressBack:(UIBarButtonItem *)sender
{
    [[self navigationController] popViewControllerAnimated:YES];
}

#pragma mark - IBActions

- (IBAction) pressSchedule:(UIButton *)sender
{
    [[HSMaster events] saveEKEventOnCalendar:lecture];
    [[HSMaster tools] dialogWithMessage:@"Esta palestra foi adicionada ao seu Calendário com sucesso."];
    [self disabledButton];
}

#pragma mark Private Methods

- (void) setFramesForPanlist
{
    // rect description
    CGRect rect1        = textDescription.frame;
    rect1.origin.y      = headerView.frame.size.height + (20*0);
    rect1.size.height   = textDescription.contentSize.height;
    [textDescription setFrame:rect1];
    [textDescription setEditable:NO];
    
    // rect button
    CGRect rect4 = butSchedule.frame;
    rect4.origin.y      = textDescription.frame.origin.y + textDescription.frame.size.height + 20;
    rect4.origin.x      = (WINDOW_WIDTH/2) - (rect4.size.width/2);
    [butSchedule setFrame:rect4];
    
    [textDescription setAlpha:1];
    [butSchedule setAlpha:1];
}
- (void) setFramesForLecture
{
    [self setFramesForPanlist];
    
    // rect title
    CGRect rect2        = labTheme.frame;
    rect2.origin.y      = textDescription.frame.size.height + textDescription.frame.origin.y;
    rect2.size.height   = 100;
    [labTheme setFrame:rect2];
    
    // rect theme
    CGRect rect3        = textTheme.frame;
    rect3.origin.y      = labTheme.frame.size.height + labTheme.frame.origin.y;
    rect3.size.height   = textTheme.contentSize.height;
    [textTheme setFrame:rect3];
    [textTheme setEditable:NO];
    
    // rect button
    CGRect rect4 = butSchedule.frame;
    rect4.origin.y      = textTheme.frame.origin.y + textTheme.frame.size.height + 20;
    rect4.origin.x      = (WINDOW_WIDTH/2) - (rect4.size.width/2);
    [butSchedule setFrame:rect4];
    
    [labTheme setAlpha:1];
    [textTheme setAlpha:1];
    
    [scroll setContentSize:CGSizeMake(headerView.frame.size.width, butSchedule.frame.origin.y+butSchedule.frame.size.height + 20)];
    NSLog(@"%f", scroll.contentSize.height);
}
- (UITextView*) createTextView
{
    UITextView *tv = [[UITextView alloc] initWithFrame:CGRectMake(10, 0, WINDOW_WIDTH-20, 350)];
    [tv setBackgroundColor:[UIColor clearColor]];
    [tv setTextColor:COLOR_DESCRIPTION];
    [tv setFont:[UIFont fontWithName:@"Helvetica" size:12.0]];
    [tv setAlpha:0];
    
    return tv;
}
- (UILabel *)createLabelTitle
{
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, WINDOW_WIDTH-20, 170)];
    [lab setFont:[UIFont fontWithName:FONT_REGULAR size:14]];
    [lab setTextColor:COLOR_TITLE];
    [lab setAlpha:0];
    [lab setNumberOfLines:6];
    
    return lab;
}

- (NSString*) changeDateLabel:(NSString*) str
{
    return str;
}
- (NSString*) changeHourLabel:(NSString*) str
{
    return str;
}
- (NSString*) stringForHour
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"HH:mm"];
    
    NSString *firstTime = [df stringFromDate:lecture.hourStart];
    NSString *lastTime  = [df stringFromDate:lecture.hourEnd];
    NSString *hour      = [NSString stringWithFormat:@"%@ %@", firstTime, lastTime];
    
    return hour;
}
- (void) disabledButton
{
    [butSchedule setEnabled:NO];
    [butSchedule setAlpha:0.5];
    [butSchedule setTitle:@"Agendado" forState:UIControlStateDisabled];
}

@end
