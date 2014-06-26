//
//  HSPanelistsViewController.m
//  HSM
//
//  Created by Felipe Ricieri on 16/06/14.
//  Copyright (c) 2014 ikomm Digital Solutions. All rights reserved.
//

#import "HSPanelistSingleViewController.h"
#import "HSPanelistsViewController.h"
#import "HSPanelistCell.h"
#import "HSPanelist.h"

@interface HSPanelistsViewController ()

@end

@implementation HSPanelistsViewController

@synthesize event;

#pragma mark - Controller Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    //
    self.title = @"Palestrantes";
    UIBarButtonItem *barbt = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btbar_back.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(pressBack:)];
    self.navigationItem.leftBarButtonItem = barbt;
    //
    rows = [[HSMaster local] panelistsForEvent:event.uniqueId];
}

#pragma mark - Actions

- (void) pressBack:(UIBarButtonItem *) sender
{
    [[self navigationController] popViewControllerAnimated:YES];
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
    HSPanelistCell *cell = (HSPanelistCell *)[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    // Configure the cell...
    HSPanelist *pan = [rows objectAtIndex:indexPath.row];
    cell.labName.text = pan.name;
    
    return cell;
}

#pragma mark - Navigation

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    HSPanelistSingleViewController *vc = (HSPanelistSingleViewController *)[segue destinationViewController];
    vc.panelist = [rows objectAtIndex:[[self.tableView indexPathForSelectedRow] row]];
}

@end
