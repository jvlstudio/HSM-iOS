//
//  HSNetworkViewController.m
//  HSM
//
//  Created by Felipe Ricieri on 16/06/14.
//  Copyright (c) 2014 ikomm Digital Solutions. All rights reserved.
//

#import "HSNetworkSingleViewController.h"
#import "HSNetworkViewController.h"

#import "HSNetworkCell.h"

@interface HSNetworkViewController ()
- (void) setConfigurations;
@end

@implementation HSNetworkViewController

#pragma mark - Controller Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setConfigurations];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // setting
    rows   = [[HSMaster network] contacts];
    [self.tableView reloadData];
    
    // ...
    selfContact = [[HSMaster network] selfCard];
    
    [selfTitle setText:selfContact.name];
    [selfSubtitle setText:selfContact.company];
    
    NSString *strImg    = [NSString stringWithFormat:@"hsm_ball_%@.png", selfContact.barcolor];
    [selfColor setImage:[UIImage imageNamed:strImg]];
    
    [[butCreate titleLabel] setFont:[UIFont fontWithName:FONT_REGULAR size:17.0]];
    [selfTitle setFont:[UIFont fontWithName:FONT_REGULAR size:selfTitle.font.pointSize]];
}

#pragma mark - Methods

- (void) setConfigurations
{
    // ...
}

#pragma mark - IBActions

- (IBAction) pressCreate:(UIButton *)sender
{
    /*
    NetworkSign *vc = [[NetworkSign alloc] initWithNibName:NIB_NETWORK_SIGN bundle:nil];
    UINavigationController *n = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:n animated:YES completion:nil];*/
}
- (IBAction) pressSelf:(UIButton *)sender
{
    selectedContact = [[HSMaster network] selfCard];
    [self performSegueWithIdentifier:@"segue_single" sender:self];
}
- (IBAction) pressScan:(UIBarButtonItem *)sender
{
    zBarReader = [ZBarReaderViewController new];
    zBarReader.readerDelegate = self;
    zBarReader.supportedOrientationsMask = ZBarOrientationMask(UIInterfaceOrientationPortrait);
    //zBarReader.cameraOverlayView = overlayView;
    
    ZBarImageScanner *scanner = zBarReader.scanner;
    
    //EXAMPLE: disable rarely used I2/5 to improve performance
    [scanner setSymbology:ZBAR_I25 config:ZBAR_CFG_ENABLE to:0];
    
    [self presentViewController:zBarReader animated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ([[HSMaster network] hasCreatedSelfCard])
        return selfView;
    else
        return nil;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [rows count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HSNetworkCell *cell;
    cell = (HSNetworkCell*)[tableView dequeueReusableCellWithIdentifier:HS_CELL_IDENTIFIER forIndexPath:indexPath];
    
    // Configure the cell...
    HSContact *contact = [rows objectAtIndex:indexPath.row];
    [[cell labName] setText:contact.name];
    [[cell labDescription] setText:contact.company];
    
    [[cell labName] setFont:[UIFont fontWithName:FONT_REGULAR size:cell.labName.font.pointSize]];
    
    NSString *strColor  = [NSString stringWithFormat:@"hsm_ball_%@.png", contact.barcolor];
    [[cell imgColor] setImage:[UIImage imageNamed:strColor]];
    
    if ([[HSMaster network] hasContactBeenAdd:contact])
        [[cell imgOpt] setImage:[UIImage imageNamed:@"id_tick.png"]];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedContact = [rows objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"segue_single" sender:self];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"segue_single"])
    {
        HSNetworkSingleViewController *vc = [segue destinationViewController];
        [vc setContact:selectedContact];
    }
}

#pragma mark - ZBarDelegate Methods

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    id<NSFastEnumeration> results = [info objectForKey:ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    
    for(symbol in results)
        //EXAMPLE: just grab the first barcode
        break;
    
    // data..
    zBarSymbolData = symbol.data;
    NSLog(@"%@", zBarSymbolData);
    
    if([[HSMaster network] isValidQRCode:zBarSymbolData])
    {
        // check if exists
        HSContact *contact = [[HSMaster network] QRCodeDecrypt:zBarSymbolData];
        // ..
        if([[HSMaster network] isContactAlreadyAdded:contact])
        {
            [zBarReader dismissViewControllerAnimated:YES completion:^{
                [[HSMaster tools] dialogWithMessage:@"Este contato já está salvo em seu Network."];
            }];
        }
        else {
            // save
            // ..
            [[HSMaster network] saveContact:contact];
            [zBarReader dismissViewControllerAnimated:YES completion:nil];
        }
    }
    else {
        [zBarReader dismissViewControllerAnimated:YES completion:^{
            [[HSMaster tools] dialogWithMessage:@"Este QR Code não é válido para adicionar um contato ao seu Network."];
        }];
    }
}

@end
