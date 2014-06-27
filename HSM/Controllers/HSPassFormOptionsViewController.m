//
//  HSPassFormOptionsViewController.m
//  HSM
//
//  Created by Felipe Ricieri on 27/06/14.
//  Copyright (c) 2014 ikomm Digital Solutions. All rights reserved.
//

#import "HSPassFormOptionsViewController.h"
#import "HSPassFormPickerCell.h"

@interface HSPassFormOptionsViewController ()

@end

@implementation HSPassFormOptionsViewController

@synthesize rows;
@synthesize currentIndexPath;
@synthesize passColor;

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - Actions

- (IBAction) pressBack:(UIBarButtonItem *)sender
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HSPassFormPickerCell *cell = (HSPassFormPickerCell *)[[HSMaster core] resourceAtIndex:kResourcePassFormPickerCell];
    cell.labText.text = [rows objectAtIndex:indexPath.row];
    
    // background..
    UIImageView *imgBg;
    imgBg   = [[UIImageView alloc] initWithImage:[UIImage imageNamed:CELL_PICKER_BG]];
    [cell setBackgroundView:imgBg];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[HSMaster passes] recordValue:[rows objectAtIndex:indexPath.row] forKey:@"label" atIndexPath:currentIndexPath withColor:passColor];
    [[self navigationController] popViewControllerAnimated:YES];
}

@end
