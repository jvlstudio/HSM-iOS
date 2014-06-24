//
//  HSEventsViewController.m
//  HSM
//
//  Created by Felipe Ricieri on 16/06/14.
//  Copyright (c) 2014 ikomm Digital Solutions. All rights reserved.
//

#import "HSEventSingleViewController.h"
#import "HSEventsViewController.h"

#import "HSEvent.h"
#import "HSEventCell.h"

@interface HSEventsViewController ()
- (void) setConfigurations;
@end

@implementation HSEventsViewController

#pragma mark - Init Methods

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - Controller Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setConfigurations];
}

#pragma mark - Methods

- (void) setConfigurations
{
    rows = [[HSMaster local] events];
    if ([rows count] == 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"Carregando...";
        [[HSMaster rest] events:^(BOOL succeed, NSDictionary *result) {
            [hud hide:YES];
            if (succeed) {
                if (result != nil) {
                    [[HSMaster local] saveEvents:[result objectForKey:@"data"]];
                    rows = [[HSMaster local] nextEvents];
                }
            }
        }];
    }
    else {
        rows = [[HSMaster local] nextEvents];
        // update in background
        [[HSMaster rest] loadInBackground:YES];
        [[HSMaster rest] events:^(BOOL succeed, NSDictionary *result) {
            if (succeed) {
                if (result != nil) {
                    [[HSMaster local] saveEvents:[result objectForKey:@"data"]];
                }
            }
        }];
    }
}

#pragma mark - IBActions

- (IBAction) changedValue:(UISegmentedControl*)sender
{
    if (segment.selectedSegmentIndex == 0)
        rows = [[HSMaster local] nextEvents];
    else
        rows = [[HSMaster local] previousEvents];
    
    [self.tableView reloadData];
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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HSEventCell *cell;
    cell = (HSEventCell*)[tableView dequeueReusableCellWithIdentifier:HS_CELL_IDENTIFIER forIndexPath:indexPath];
    
    // Configure the cell...
    HSEvent *event = [rows objectAtIndex:indexPath.row];
    
    [cell.labTitle setText:event.name];
    [cell.labSubtitle setText:event.shortDescription];
    [cell.labLocal setText:event.local];
    //[cell.labDates setText:event.dates];
    
    [cell.labTitle setFont:[UIFont fontWithName:FONT_REGULAR size:cell.labTitle.font.pointSize]];
    //[[cell labSubtext] setFont:[UIFont fontWithName:FONT_REGULAR size:cell.labSubtext.font.pointSize]];
    [cell.labLocal setFont:[UIFont fontWithName:FONT_REGULAR size:cell.labLocal.font.pointSize]];
    [cell.labDates setFont:[UIFont fontWithName:FONT_REGULAR size:cell.labDates.font.pointSize]];
    
    NSString *strImg    = [NSString stringWithFormat:@"events_list_%@.png", event.slug];
    [cell.imgBackground setImage:[UIImage imageNamed:strImg]];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedEvent = (HSEvent *)[rows objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"segue_single" sender:self];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    HSEventSingleViewController *vc = (HSEventSingleViewController *) segue.destinationViewController;
    vc.event = selectedEvent;
}

@end
