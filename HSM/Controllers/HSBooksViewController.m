//
//  HSBooksViewController.m
//  HSM
//
//  Created by Felipe Ricieri on 16/06/14.
//  Copyright (c) 2014 ikomm Digital Solutions. All rights reserved.
//

#import "HSBookSingleViewController.h"
#import "HSBooksViewController.h"

#import "HSBook.h"
#import "HSBookCell.h"

@interface HSBooksViewController ()
- (void) setConfigurations;
@end

@implementation HSBooksViewController

#pragma mark - Controller Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - Methods

- (void) setConfigurations
{
    rows = [[HSMaster local] books];
}
#pragma mark - Methods

- (HSBook *) book
{
    return selectedBook;
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
    HSBookCell *cell;
    cell = (HSBookCell*)[tableView dequeueReusableCellWithIdentifier:HS_CELL_IDENTIFIER forIndexPath:indexPath];
    
    // Configure the cell...
    HSBook *book = [rows objectAtIndex:indexPath.row];
    
    [cell.labTitle setText:book.title];
    [cell.labSubtitle setText:book.description];
    [cell.imgPicture setImage:[UIImage imageNamed:@""]];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedBook = (HSBook *)[rows objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"segue_single" sender:self];
}

#pragma mark - Navigation

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"segue_single"])
    {
        HSBookSingleViewController *vc = [segue destinationViewController];
        [vc setBook:selectedBook];
    }
}

@end
