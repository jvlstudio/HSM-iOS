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
    if ([rows count] == 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"Carregando...";
        [[HSMaster rest] books:^(BOOL succeed, NSDictionary *result) {
            [hud hide:YES];
            if (succeed) {
                if (result != nil) {
                    [[HSMaster local] saveBooks:[result objectForKey:@"data"]];
                    rows = [[HSMaster local] books];
                }
            }
        }];
    }
    else {
        // update in background
        [[HSMaster rest] loadInBackground:YES];
        [[HSMaster rest] books:^(BOOL succeed, NSDictionary *result) {
            if (succeed) {
                if (result != nil) {
                    [[HSMaster local] saveBooks:[result objectForKey:@"data"]];
                }
            }
        }];
    }
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
