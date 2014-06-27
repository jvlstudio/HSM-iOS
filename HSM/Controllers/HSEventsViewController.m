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

@end

@implementation HSEventsViewController

#pragma mark - Controller Methods

- (void) viewDidLoad
{
    [super viewDidLoad];
    rows = [[HSMaster local] events];
}
- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // check..
    if ([rows count] == 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"Carregando Eventos...";
        [[HSMaster rest] events:^(BOOL succeed, NSDictionary *result) {
            [hud hide:YES];
            if (succeed) {
                if (result != nil) {
                    [[HSMaster local] saveEvents:[result objectForKey:@"data"]];
                    rows = [[HSMaster local] nextEvents];
                    [self.tableView reloadData];
                }
            }
        }];
    }
    else {
        rows = [[HSMaster local] nextEvents];
        [self.tableView reloadData];
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
    [cell.labDates setText:event.datePretty];
    
    [cell.labTitle setFont:[UIFont fontWithName:FONT_REGULAR size:cell.labTitle.font.pointSize]];
    //[[cell labSubtext] setFont:[UIFont fontWithName:FONT_REGULAR size:cell.labSubtext.font.pointSize]];
    [cell.labLocal setFont:[UIFont fontWithName:FONT_REGULAR size:cell.labLocal.font.pointSize]];
    [cell.labDates setFont:[UIFont fontWithName:FONT_REGULAR size:cell.labDates.font.pointSize]];
    
    [cell.imgBackground setImageWithURL:[NSURL URLWithString:event.pictureList]];
    
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"segue_single"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        HSEventSingleViewController *destViewController = segue.destinationViewController;
        destViewController.event = [rows objectAtIndex:indexPath.row];
    }
}

@end
