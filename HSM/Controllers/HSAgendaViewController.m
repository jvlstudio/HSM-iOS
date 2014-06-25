//
//  HSAgendaViewController.m
//  HSM
//
//  Created by Felipe Ricieri on 16/06/14.
//  Copyright (c) 2014 ikomm Digital Solutions. All rights reserved.
//

#import "HSPanelistSingleViewController.h"
#import "HSAgendaViewController.h"

#import "HSAgendaCell.h"
#import "HSAgendaPauseCell.h"

#define CELL_HEIGHT             95.0
#define CELL_BREAK_HEIGHT       43.0
#define CELL_BG                 @"hsm_v5_agenda_cell_speech.png"
#define CELL_BG_2               @"hsm_v5_agenda_cell_speech_sel.png"
#define CELL_BG_3               @"hsm_v5_agenda_cell.png"

#pragma mark - Interface

@interface HSAgendaViewController ()
- (void) manageButtons;
@end

#pragma mark - Implementation

@implementation HSAgendaViewController

@synthesize event;

#pragma mark - Controller Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    //
    agendaDays   = [[HSMaster local] agendaForEvent:event.uniqueId];
    if ([agendaDays count] > 0) {
        scheduleDays = [[HSMaster local] agenda:agendaDays splitedByDays:event];
        rows   = [scheduleDays objectAtIndex:0];
    }
    else {
        rows = [NSArray array];
    }
    [self manageButtons];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"event: %@", event.uniqueId);
    // check
    if ([agendaDays count] == 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"Carregando Agenda...";
        [[HSMaster rest] agendaForEvent:event.uniqueId completion:^(BOOL succeed, NSDictionary *result) {
            [hud hide:YES];
            if (succeed) {
                if (result != nil) {
                    [[HSMaster local] saveAgenda:[result objectForKey:@"data"] forEvent:event.uniqueId];
                    agendaDays  = [[HSMaster local] agendaForEvent:event.uniqueId];
                    scheduleDays= [[HSMaster local] agenda:agendaDays splitedByDays:event];
                    rows        = [scheduleDays objectAtIndex:0];
                    [self manageButtons];
                    [self.tableView reloadData];
                }
            }
        }];
    }
    else {
        // update in background
        [[HSMaster rest] loadInBackground:YES];
        [[HSMaster rest] agendaForEvent:event.uniqueId completion:^(BOOL succeed, NSDictionary *result) {
            if (succeed) {
                if (result != nil) {
                    [[HSMaster local] saveAgenda:[result objectForKey:@"data"] forEvent:event.uniqueId];
                }
            }
        }];
    }
}

#pragma mark - IBActions

- (IBAction) segmentChanged:(UISegmentedControl*)sender
{
    rows = [scheduleDays objectAtIndex:sender.selectedSegmentIndex];
    [self.tableView reloadData];
}
- (IBAction) pressBack:(UIBarButtonItem *)sender
{
    [[self navigationController] popViewControllerAnimated:YES];
}

#pragma mark - Private Methods

- (void) manageButtons
{
    if ([agendaDays count] == 1)
        [self.tableView setTableHeaderView:nil];
    if ([agendaDays count] == 2)
        [segment removeSegmentAtIndex:2 animated:NO];
    
    int i=0;
    for (NSDate *date in event.dates) {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"dd/MMM"];
        [segment setTitle:[df stringFromDate:date] forSegmentAtIndex:i];
        i++;
    }
    
    [segment setSelectedSegmentIndex:0];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [rows count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HSLecture *dict  = [rows objectAtIndex:indexPath.row];
    if (dict.type == kTypeLecture || dict.type == kTypePromotion)
        return CELL_HEIGHT;
    else
        return CELL_BREAK_HEIGHT;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // agenda object
    HSLecture *dict     = [rows objectAtIndex:indexPath.row];
    id cell             = nil;
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"HH:mm"];
    
    // is "lecture"
    if (dict.type == kTypeLecture)
    {
        cell     = (HSAgendaCell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
        // bg
        UIImageView *imgBg;
        if ([[HSMaster events] isPanelistScheduled:dict])
            imgBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:CELL_BG_2]];
        else
            imgBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:CELL_BG]];
        [cell setBackgroundView:imgBg];
        
        [[cell imgPicture] setImage:[UIImage imageNamed:dict.panelist.pictureURL]];
        [[cell labTitle] setText:dict.title];
        [[cell labSubtitle] setText:dict.subtitle];
        [[cell labHourStart] setText:[df stringFromDate:dict.hourStart]];
        [[cell labHourEnd] setText:[df stringFromDate:dict.hourEnd]];
        
        [[cell labTitle] alignBottom];
        [[cell labSubtitle] alignTop];
        
        [[cell labTitle] setFont:[UIFont fontWithName:FONT_REGULAR size:15.0]];
        //[[cell labSubtitle] setFont:[UIFont fontWithName:FONT_REGULAR size:12.0]];
    }
    // is "promotion"
    else if (dict.type == kTypePromotion)
    {
        cell     = (HSAgendaCell*)[tableView dequeueReusableCellWithIdentifier:@"cell"];
        
        [[cell labSubtitle] setTextColor:[UIColor whiteColor]];
        
        // bg
        UIImageView *imgBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:CELL_BG_3]];
        [cell setBackgroundView:imgBg];
        
        [[cell labTitle] setText:dict.title];
        [[cell labSubtitle] setText:dict.subtitle];
        [[cell labHourStart] setText:[df stringFromDate:dict.hourStart]];
        [[cell labHourEnd] setText:[df stringFromDate:dict.hourEnd]];
        
        [[cell labTitle] alignBottom];
        [[cell labTitle] setFont:[UIFont fontWithName:FONT_REGULAR size:15.0]];
    }
    // is "pause"
    else {
        cell = (HSAgendaPauseCell*)[[HSMaster core] resourceAtIndex:kResourceAgendaPause];
        
        // hour
        NSString *strImg = [NSString stringWithFormat:@"agenda_id_%@.png", dict.subtitle];
        
        // ..
        [[cell imgIcon] setImage:[UIImage imageNamed:strImg]];
        [[cell labTitle] setText:dict.title];
        [[cell labHourStart] setText:[df stringFromDate:dict.hourStart]];
        [[cell labHourEnd] setText:[df stringFromDate:dict.hourEnd]];
        
        [[cell labTitle] setFont:[UIFont fontWithName:FONT_REGULAR size:15.0]];
    }
    
    return cell;
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HSLecture *lecture = [rows objectAtIndex:indexPath.row];
    
    // is "lecture"
    if (lecture.type == kTypeLecture) {
        UIStoryboard *panelistSB = [UIStoryboard storyboardWithName:@"Panelists" bundle:nil];
        HSPanelistSingleViewController *vc = (HSPanelistSingleViewController *)[panelistSB instantiateViewControllerWithIdentifier:@"panelist_single"];
        vc.lecture = lecture;
        [[self navigationController] pushViewController:vc animated:YES];
    }
}

@end
