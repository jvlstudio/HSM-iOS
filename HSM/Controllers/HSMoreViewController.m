//
//  HSMoreViewController.m
//  HSM
//
//  Created by Felipe Ricieri on 16/06/14.
//  Copyright (c) 2014 ikomm Digital Solutions. All rights reserved.
//

#import "HSMagazinesViewController.h"
#import "HSMoreViewController.h"

#import "HSMoreCell.h"

@interface HSMoreViewController ()
- (void) setConfigurations;
@end

@implementation HSMoreViewController

#pragma mark - Controller Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setConfigurations];
}

#pragma mark - Methods

- (void) setConfigurations
{
    rows = @[ @{ @"slug" : @"issues", @"name" : @"HSM Editora"},
              @{ @"slug" : @"tv", @"name" : @"HSM Vídeos"} ];
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
    HSMoreCell *cell;
    cell = (HSMoreCell*)[tableView dequeueReusableCellWithIdentifier:HS_CELL_IDENTIFIER forIndexPath:indexPath];
    
    // Configure the cell...
    NSDictionary *dict = [rows objectAtIndex:indexPath.row];
    [cell.labTitle setText:[dict objectForKey:@"name"]];
    [cell.imgIcon setImage:[UIImage imageNamed:[NSString stringWithFormat:@"icon_%@.png", [dict objectForKey:@"slug"]]]];
    
    [cell.labTitle setFont:[UIFont fontWithName:FONT_BOLD size:cell.labTitle.font.pointSize]];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [rows objectAtIndex:indexPath.row];
    if ([[dict objectForKey:@"slug"] isEqualToString:@"issues"]) {
        [self performSegueWithIdentifier:@"segue_magazines" sender:self];
    }
    else {
        NSString *strURL = @"http://www.youtube.com/watch?v=ZHolmn4LBzg";
        NSURL *url = [ [ NSURL alloc ] initWithString: strURL ];
        [[UIApplication sharedApplication] openURL:url];
    }
}

#pragma mark - Navigation

/*
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"segue_magazines"])
    {
        HSMagazinesViewController *vc = [segue destinationViewController];
    }
}
*/

@end
