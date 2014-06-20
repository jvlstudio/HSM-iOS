//
//  HSMagazinesViewController.m
//  HSM
//
//  Created by Felipe Ricieri on 16/06/14.
//  Copyright (c) 2014 ikomm Digital Solutions. All rights reserved.
//

#import "HSMagazinesViewController.h"
#import "HSMagazineCell.h"

@interface HSMagazinesViewController ()
- (void) setConfigurations;
@end

@implementation HSMagazinesViewController

#pragma mark - Controller Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setConfigurations];
}

#pragma mark - Methods

- (void) setConfigurations
{
    rows = [[HSMaster local] magazines];
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
    HSMagazineCell *cell;
    cell = (HSMagazineCell*)[tableView dequeueReusableCellWithIdentifier:HS_CELL_IDENTIFIER forIndexPath:indexPath];
    
    // Configure the cell...
    HSMagazine *magazine = [rows objectAtIndex:indexPath.row];
    [cell.labTitle setText:magazine.name];
    [cell.labSubtitle setText:magazine.edition];
    
    [[cell labTitle] setFont:[UIFont fontWithName:FONT_REGULAR size:cell.labTitle.font.pointSize]];
    [[cell labTitle] alignBottom];
    [[cell labSubtitle] alignTop];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //HSMagazine *magazine = [rows objectAtIndex:indexPath.row];
    NSString *urlToOpen = @"https://itunes.apple.com/us/app/hsm-revista/id517676208?l=pt&ls=1&mt=8";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlToOpen]];
}

@end
