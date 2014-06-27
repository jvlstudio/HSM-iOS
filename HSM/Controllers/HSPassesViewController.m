//
//  HSPassesViewController.m
//  HSM
//
//  Created by Felipe Ricieri on 16/06/14.
//  Copyright (c) 2014 ikomm Digital Solutions. All rights reserved.
//

#import "HSPassFormViewController.h"
#import "HSPassesViewController.h"
#import "HSPassCell.h"
#import "HSPass.h"

@interface HSPassesViewController ()

@end

@implementation HSPassesViewController

@synthesize event;

#pragma mark - Controller Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    //
    rows = [[HSMaster local] passesForEvent:event.uniqueId];
}

#pragma mark - IBActions

- (IBAction) pressClose:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table Methods

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
    HSPassCell *cell = (HSPassCell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    // configure..
    HSPass *pass = [rows objectAtIndex:indexPath.row];
    cell.labTitle.text          = pass.name;
    cell.labDescription.text    = pass.description;
    cell.labValue.text          = [NSString stringWithFormat:@"Preço Normal: R$%@", pass.value];
    cell.labValuePromo.text     = pass.valuePromo;
    cell.labValidto.text        = [NSString stringWithFormat:@"Válido até: %@", pass.validTo];
    cell.imgBackground.image    = [UIImage imageNamed:[NSString stringWithFormat:@"pass_%@.png", [HS_PASS_COLORS objectAtIndex:pass.color]]];
    
    return cell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    HSPass *pass = [rows objectAtIndex:[[self.tableView indexPathForSelectedRow] row]];
    HSPassFormViewController *vc = (HSPassFormViewController *)[segue destinationViewController];
    vc.pass = pass;
    vc.event = event;
}

@end
