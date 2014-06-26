//
//  HSPassFormViewController.m
//  HSM
//
//  Created by Felipe Ricieri on 16/06/14.
//  Copyright (c) 2014 ikomm Digital Solutions. All rights reserved.
//

#import "HSPassFormAddViewController.h"
#import "HSPassDoneViewController.h"
#import "HSPassFormViewController.h"

#import "HSPassFormCell.h"
#import "HSPassFormPickerCell.h"
#import "HSPassFormPickerPaymentCell.h"
#import "HSPassFormAddCell.h"
#import "HSPassFormEditCell.h"
#import "HSPassFormSectionView.h"
#import "HSPassHeaderView.h"
#import "HSPassPickerView.h"

#import "HSPassButton.h"

#define HS_URL_PASS_ADD @"http://apps.ikomm.com.br/hsm/graph/pass-add.php"

@interface HSPassFormViewController ()
- (void) reloadTableData;
@end

@implementation HSPassFormViewController
{
    NSIndexPath *touchedIndexPath;
}

@synthesize pass;
@synthesize event;

#pragma mark - Controller Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    //
    dates = event.dates;
    
    // ...
    [self reloadTableData];
    
    NSString *strImg    = [NSString stringWithFormat:TITLE_BG, [self stringForPassColor:pass.color]];
    [imgHeader setImage:[UIImage imageNamed:strImg]];
    
    touchedIndexPath = [[NSIndexPath alloc] init];
    
    // ...
    [pvDates setFrame:RECT_PICKER_HIDE];
    [pvPayment setFrame:RECT_PICKER_HIDE];
    [[self view] addSubview:pvDates];
    [[self view] addSubview:pvPayment];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self reloadTableData];
}

#pragma mark - IBActions

- (IBAction) pressConfirm:(UIButton *)sender
{
    [self saveFormDataToPropertyList];
}
- (IBAction) pressBack:(UIBarButtonItem *)sender
{
    [[self navigationController] popViewControllerAnimated:YES];
}
- (void) pressDelete:(UIButton *)sender
{
    HSPassButton *bt = (HSPassButton*)sender;
    touchedIndexPath = bt.indexPath;
    
    [[HSMaster tools] promptWithMessage:@"Tem certeza que deseja excluir este participante?" completionYes:^{
        [self removeParticipantAtIndexPath:touchedIndexPath];
        [self reloadTableData];
    } completionNo:^{
        // nothing happens..
    }];
}

#pragma mark - Private Methods

- (void) reloadTableData
{
    plist       = [[HSMaster tools] propertyListRead:HS_PLIST_PASSES_MODEL];
    passData    = [plist objectAtIndex:pass.color];
    passSections= [passData objectForKey:@"sections"];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [passSections count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [self heightForCellType:kCellTypeSubtitle];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    HSPassFormSectionView *subTitle = (HSPassFormSectionView*)[[HSMaster core] resourceAtIndex:kResourcePassFormSection];
    NSDictionary *obj               = [passSections objectAtIndex:section];
    NSInteger numSection            = section+1;
    NSString *strBg                 = [NSString stringWithFormat:CELL_SUBTITLE_BG, [self stringForPassColor:pass.color]];
    UIImage *imgBg                  = [UIImage imageNamed:strBg];
    
    [[subTitle labNum] setText:[NSString stringWithFormat:@"%i", numSection]];
    [[subTitle labText] setText:[obj objectForKey:@"label"]];
    [[subTitle imgBg] setImage:imgBg];
    
    return subTitle;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[passSections objectAtIndex:section] objectForKey:@"rows"] count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *rows = [[passSections objectAtIndex:indexPath.section] objectForKey:@"rows"];
    HSPassCellType type = (HSPassCellType)[[[rows objectAtIndex:indexPath.row] objectForKey:@"type"] intValue];
    return [self heightForCellType:type];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // dict..
    NSInteger section   = indexPath.section;
    NSInteger row       = indexPath.row;
    NSDictionary *dict  = [[[passSections objectAtIndex:section] objectForKey:@"rows"] objectAtIndex:row];
    // xib..
    UIImageView *imgBg;
    // cell..
    id cell             = nil;
    
    HSPassCellType type   = [[dict objectForKey:@"type"] intValue];
    switch (type)
    {
        // picker
        case kCellTypePicker:
        {
            // picker
            cell = (HSPassFormPickerCell*)[[HSMaster core] resourceAtIndex:kResourcePassFormPickerCell];
            [[cell labText] setText:@"Selecione..."];
            
            // background..
            imgBg   = [[UIImageView alloc] initWithImage:[UIImage imageNamed:CELL_PICKER_BG]];
            [cell setBackgroundView:imgBg];
        }
            break;
        // payment
        case kCellTypePickerPayment:
        {
            // picker (payment)
            cell = (HSPassFormPickerPaymentCell*)[[HSMaster core] resourceAtIndex:kResourcePassFormPaymentCell];
            [[cell labText] setText:[dict objectForKey:@"label"]];
            
            // background..
            imgBg   = [[UIImageView alloc] initWithImage:[UIImage imageNamed:CELL_PICKER_PAYMENT_BG]];
            [cell setBackgroundView:imgBg];
        }
            break;
        // cell
        case kCellTypeForm:
        {
            // form
            cell = (HSPassFormCell*)[[HSMaster core] resourceAtIndex:kResourcePassFormCell];
            [[cell labText] setText:[dict objectForKey:@"label"]];
            
            // background..
            imgBg   = [[UIImageView alloc] initWithImage:[UIImage imageNamed:CELL_FORM_BG]];
            [cell setBackgroundView:imgBg];
        }
            break;
        // add
        case kCellTypeAdd:
        {
            // add..
            cell = (HSPassFormAddCell *)[[HSMaster core] resourceAtIndex:kResourcePassFormAddCell];
            [[cell labText] setText:[dict objectForKey:@"label"]];
            
            // background..
            imgBg   = [[UIImageView alloc] initWithImage:[UIImage imageNamed:CELL_ADD_BG]];
            [cell setBackgroundView:imgBg];
        }
            break;
        // edit
        case kCellTypeEdit:
        {
            // add..
            cell = (HSPassFormEditCell *)[[HSMaster core] resourceAtIndex:kResourcePassFormEditCell];
            [[cell labText] setText:[dict objectForKey:@"label"]];
            
            if(![[dict objectForKey:@"can_remove"] isEqualToString:@"yes"])
                [[cell but] setHidden:YES];
            
            HSPassButton *bt = (HSPassButton*)[cell but];
            [bt setIndexPath:indexPath];
            [bt addTarget:self action:@selector(pressDelete:) forControlEvents:UIControlEventTouchUpInside];
            
            // background..
            imgBg   = [[UIImageView alloc] initWithImage:[UIImage imageNamed:CELL_EDIT_BG]];
            [cell setBackgroundView:imgBg];
        }
            break;
            // ...
        case kCellTypeSubtitle:
        default:
            // nothing for subtitle and default...
            break;
    }
    
    return cell;
}

#pragma mark - Picker Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == pvDates)
        return [dates count];
    else
        return [VALUES_PAYMENT count];
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd /d/e MMM, YYYY"];
    NSDate *date = [dates objectAtIndex:row];
    if (pickerView == pvDates)
        return [df stringFromDate:date];
    else
        return [VALUES_PAYMENT objectAtIndex:row];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    // dates..
    if (pickerView == pvDates)
    {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"dd /d/e MMM, YYYY"];
        NSDate *date = [dates objectAtIndex:row];
        
        HSPassFormPickerCell *cell = (HSPassFormPickerCell*)[self.tableView cellForRowAtIndexPath:touchedIndexPath];
        [[cell labText] setText:[dates objectAtIndex:row]];
        [self recordValue:[df stringFromDate:date] forKey:@"label" atIndexPath:touchedIndexPath];
    }
    // payment..
    else {
        HSPassFormPickerPaymentCell *cell = (HSPassFormPickerPaymentCell*)[self.tableView cellForRowAtIndexPath:touchedIndexPath];
        [[cell labText] setText:[VALUES_PAYMENT objectAtIndex:row]];
        [self recordValue:[VALUES_PAYMENT objectAtIndex:row] forKey:@"label" atIndexPath:touchedIndexPath];
    }
    
    [self.tableView setUserInteractionEnabled:YES];
    [self pickerHide:pickerView];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


/*
 *
 Manager Methods
 *
 */

#pragma mark - Record Methods

+ (void)recordValue:(NSString *)value forKey:(NSString *)key atIndexPath:(NSIndexPath *)ip
{
    NSMutableArray *dplist          = [[HSMaster tools] propertyListRead:HS_PLIST_PASSES_MODEL];
    NSMutableDictionary *dpass      = [dplist objectAtIndex:pass.color];
    NSMutableArray *sections        = [dpass objectForKey:@"sections"];
    NSMutableDictionary *secDict    = [sections objectAtIndex:ip.section];
    NSMutableArray *rows            = [secDict objectForKey:@"rows"];
    NSMutableDictionary *row        = [rows objectAtIndex:0];
    
    [row setObject:value forKey:key];
    
    [rows setObject:row atIndexedSubscript:0];
    [secDict setObject:rows forKey:@"rows"];
    [sections setObject:secDict atIndexedSubscript:ip.section];
    [dpass setObject:sections forKey:@"sections"];
    [dplist setObject:dpass atIndexedSubscript:pass.color];
    
    [[HSMaster tools] propertyListWrite:dplist forFileName:HS_PLIST_PASSES_MODEL];
}
+ (void)recordParticipant:(NSMutableDictionary *)dict atIndexPath:(NSIndexPath *)ip
{
    NSMutableArray *dplist          = [[HSMaster tools] propertyListRead:HS_PLIST_PASSES_MODEL];
    NSMutableDictionary *dpass      = [dplist objectAtIndex:pass.color];
    NSMutableArray *sections        = [dpass objectForKey:@"sections"];
    NSMutableDictionary *secDict    = [sections objectAtIndex:ip.section];
    NSMutableArray *rows            = [secDict objectForKey:@"rows"];
    
    NSInteger totalOfRows           = [rows count];
    NSInteger indexLastRow          = totalOfRows - 1;
    NSInteger limitOfRows           = [[secDict objectForKey:@"limit"] intValue];
    
    NSDictionary *addAnother        = [NSDictionary dictionaryWithObjectsAndKeys:
                                       @"4", @"type",
                                       @"add", @"subtype",
                                       @"Adicionar Participante", @"label", nil];
    NSMutableDictionary *row        = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"5", @"type",
                                       @"edit", @"subtype",
                                       @"yes", @"can_remove",
                                       [dict objectForKey:@"name"], @"label",
                                       dict, @"values", nil];
    
    // ...
    if (limitOfRows == 1)
        [row setObject:@"no" forKey:@"can_remove"];
    
    // add or edit?
    NSDictionary *tempDict = [self rowAtIndexPath:ip];
    if ([[tempDict objectForKey:@"subtype"] isEqualToString:@"edit"])
    {
        [rows setObject:row atIndexedSubscript:ip.row];
    }
    else {
        [rows setObject:row atIndexedSubscript:indexLastRow];
        if(limitOfRows > [rows count])
            [rows addObject:addAnother];
    }
    
    [secDict setObject:rows forKey:@"rows"];
    [sections setObject:secDict atIndexedSubscript:ip.section];
    [dpass setObject:sections forKey:@"sections"];
    [dplist setObject:dpass atIndexedSubscript:pass.color];
    
    [[HSMaster tools] propertyListWrite:plist forFileName:HS_PLIST_PASSES_MODEL];
}
+ (NSDictionary *) rowAtIndexPath:(NSIndexPath *)ip
{
    NSMutableArray *dplist          = [[HSMaster tools] propertyListRead:HS_PLIST_PASSES_MODEL];
    NSMutableDictionary *dpass      = [dplist objectAtIndex:pass.color];
    NSMutableArray *sections        = [dpass objectForKey:@"sections"];
    NSMutableDictionary *secDict    = [sections objectAtIndex:ip.section];
    NSMutableArray *rows            = [secDict objectForKey:@"rows"];
    NSDictionary *row               = [rows objectAtIndex:ip.row];
    
    return row;
}
+ (BOOL) removeParticipantAtIndexPath:(NSIndexPath*) ip
{
    NSDictionary *addAnother        = [NSDictionary dictionaryWithObjectsAndKeys:
                                       @"4", @"type",
                                       @"add", @"subtype",
                                       @"Adicionar Participante", @"label", nil];
    
    NSMutableArray *dplist          = [[HSMaster tools] propertyListRead:HS_PLIST_PASSES_MODEL];
    NSMutableDictionary *dpass      = [dplist objectAtIndex:pass.color];
    NSMutableArray *sections        = [dpass objectForKey:@"sections"];
    NSMutableDictionary *secDict    = [sections objectAtIndex:ip.section];
    NSMutableArray *rows            = [secDict objectForKey:@"rows"];
    
    if ([rows count] == 5)
        [rows addObject:addAnother];
    [rows removeObjectAtIndex:ip.row];
    
    [secDict setObject:rows forKey:@"rows"];
    [sections setObject:secDict atIndexedSubscript:ip.section];
    [dpass setObject:sections forKey:@"sections"];
    [dplist setObject:dpass atIndexedSubscript:pass.color];
    
    if([[HSMaster tools] propertyListWrite:dplist forFileName:HS_PLIST_PASSES_MODEL])
        return YES;
    else
        return NO;
}

- (void) saveFormDataToPropertyList
{
    NSMutableDictionary *plistInfo  = [NSMutableDictionary dictionary];
    
    NSMutableArray *dplist          = [[HSMaster tools] propertyListRead:HS_PLIST_PASSES_MODEL];
    NSMutableDictionary *dpass      = [dplist objectAtIndex:pass.color];
    NSMutableArray *sections        = [dpass objectForKey:@"sections"];
    
    //
    switch (pass.color)
    {
        // green..
        case kColorGreen:
        {
            NSMutableDictionary *secDate    = [sections objectAtIndex:0];
            NSMutableArray *rowsDate        = [secDate objectForKey:@"rows"];
            
            NSMutableDictionary *secPart    = [sections objectAtIndex:1];
            NSMutableArray *rowsPart        = [secPart objectForKey:@"rows"];
            
            NSMutableDictionary *secPaym    = [sections objectAtIndex:2];
            NSMutableArray *rowsPaym        = [secPaym objectForKey:@"rows"];
            
            NSString *valueDates            = [[rowsDate objectAtIndex:0] objectForKey:@"label"];
            NSString *valuePayment          = [[rowsPaym objectAtIndex:0] objectForKey:@"label"];
            NSDictionary *part              = [[rowsPart objectAtIndex:0] objectForKey:@"values"];
            
            // ..
            // validate
            if ([valueDates isEqualToString:@""]
            ||  [valueDates isEqualToString:@"Selecione..."]
            ||  [part count] < 1)
            {
                NSLog(@"[HS_PASSES] ------");
                NSLog(@"[HS_PASSES] part count: %i", [part count]);
                [[HSMaster tools] dialogWithMessage:@"Por favor, preencha todos os campos antes de prosseguir."];
                return;
            }
            else
            {
                [plistInfo setObject:valueDates forKey:KEY_FORM_DATE];
                [plistInfo setObject:valuePayment forKey:KEY_FORM_PAYMENT];
                [plistInfo setObject:rowsPart forKey:KEY_FORM_PARTICIPANT];
                
                [[HSMaster tools] propertyListWrite:plistInfo forFileName:HS_PLIST_PASSES_COMPLETED];
                NSDictionary *passCompleted = [[HSMaster tools] propertyListRead:HS_PLIST_PASSES_COMPLETED];
                NSLog(@"[HS_PASSES] %@", passCompleted);
                // ...
                [self sendPassEmailToHSM];
            }
        }
            break;
            // gold..
        case kColorGold:
        case kColorRed:
        {
            NSMutableDictionary *secPart    = [sections objectAtIndex:0];
            NSMutableArray *rowsPart        = [secPart objectForKey:@"rows"];
            
            NSMutableDictionary *secPaym    = [sections objectAtIndex:1];
            NSMutableArray *rowsPaym        = [secPaym objectForKey:@"rows"];
            
            NSString *valuePayment          = [[rowsPaym objectAtIndex:0] objectForKey:@"label"];
            NSDictionary *part              = [[rowsPart objectAtIndex:0] objectForKey:@"values"];
            
            // ..
            // validate
            if ([part count] < 1)
            {
                NSLog(@"[HS_PASSES] part count: %i", [part count]);
                [[HSMaster tools] dialogWithMessage:@"Por favor, preencha todos os campos antes de prosseguir."];
                return;
            }
            else
            {
                [plistInfo setObject:valuePayment forKey:KEY_FORM_PAYMENT];
                [plistInfo setObject:rowsPart forKey:KEY_FORM_PARTICIPANT];
                
                [[HSMaster tools] propertyListWrite:plistInfo forFileName:HS_PLIST_PASSES_COMPLETED];
                NSDictionary *passCompleted = [[HSMaster tools] propertyListRead:HS_PLIST_PASSES_COMPLETED];
                NSLog(@"[HS_PASSES] %@", passCompleted);
                // ...
                [self sendPassEmailToHSM];
            }
        }
            break;
    }
}
- (void) sendPassEmailToHSM
{
    NSDictionary *dict  = [[HSMaster tools] propertyListRead:HS_PLIST_PASSES_COMPLETED];
    NSDictionary *part;
    NSString *stringToRequest;
    
    // ...
    switch (pass.color)
    {
        case kColorGreen:
        {
            part = [[[dict objectForKey:KEY_FORM_PARTICIPANT] objectAtIndex:0] objectForKey:@"values"];
            // proceed..
            stringToRequest = [NSString stringWithFormat:@"%@?os=ios&to_email=%@&event_name=%@color=green&day=%@&payment=%@&name=%@&email=%@&cpf=%@&company=%@&role=%@",
                               HS_URL_PASS_ADD,
                               [pass.email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                               [event.name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                               [[dict objectForKey:KEY_FORM_DATE] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                               [[dict objectForKey:KEY_FORM_PAYMENT] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                               [[part objectForKey:@"name"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                               [[part objectForKey:@"email"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                               [[part objectForKey:@"cpf"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                               [[part objectForKey:@"company"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                               [[part objectForKey:@"role"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        }
            break;
        case kColorGold:
        {
            part = [[[dict objectForKey:KEY_FORM_PARTICIPANT] objectAtIndex:0] objectForKey:@"values"];
            // proceed..
            stringToRequest = [NSString stringWithFormat:@"%@?os=ios&to_email=%@&event_name=%@&color=gold&payment=%@&name=%@&email=%@&cpf=%@&company=%@&role=%@",
                               HS_URL_PASS_ADD,
                               [pass.email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                               [event.name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                               [[dict objectForKey:KEY_FORM_PAYMENT] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                               [[part objectForKey:@"name"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                               [[part objectForKey:@"email"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                               [[part objectForKey:@"cpf"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                               [[part objectForKey:@"company"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                               [[part objectForKey:@"role"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        }
            break;
        case kColorRed:
        {
            stringToRequest = [NSString stringWithFormat:@"%@?os=ios&to_email=%@&event_name=%@&color=red&payment=%@",
                               HS_URL_PASS_ADD,
                               [pass.email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                               [event.name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                               [[dict objectForKey:KEY_FORM_PAYMENT] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            NSArray *parts = [dict objectForKey:KEY_FORM_PARTICIPANT];
            int pointer = 0;
            for (NSDictionary *dict in parts)
            {
                part = [dict objectForKey:@"values"];
                stringToRequest = [stringToRequest stringByAppendingFormat:@"&people[%i][%@]=%@",
                                   pointer, @"name",
                                   [[part objectForKey:@"name"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                stringToRequest = [stringToRequest stringByAppendingFormat:@"&people[%i][%@]=%@",
                                   pointer, @"email",
                                   [[part objectForKey:@"email"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                stringToRequest = [stringToRequest stringByAppendingFormat:@"&people[%i][%@]=%@",
                                   pointer, @"cpf",
                                   [[part objectForKey:@"cpf"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                stringToRequest = [stringToRequest stringByAppendingFormat:@"&people[%i][%@]=%@",
                                   pointer, @"company",
                                   [[part objectForKey:@"company"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                stringToRequest = [stringToRequest stringByAppendingFormat:@"&people[%i][%@]=%@",
                                   pointer, @"role",
                                   [[part objectForKey:@"role"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                pointer++;
            }
        }
            break;
    }
    
    // register..
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
    hud.labelText = @"Enviando...";
    [[HSMaster rest] passesEmail:stringToRequest completion:^(BOOL succeed, NSDictionary *result) {
        [hud hide:YES];
        [self finishProcess];
    }];
}
- (void) finishProcess
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:@"yes" forKey:@"passcode_sent"];
    [def synchronize];
    
    [self performSegueWithIdentifier:@"segue_done" sender:self];
}

#pragma mark -
#pragma mark Table Methods

- (NSInteger) heightForCellType:(HSPassCellType) cellType
{
    NSInteger height = 0;
    switch (cellType)
    {
        case kCellTypeSubtitle:
        {
            height = 63.0;
        }
            break;
        case kCellTypeForm:
        {
            height = 264.0;
        }
            break;
        case kCellTypePicker:
        case kCellTypePickerPayment:
        case kCellTypeAdd:
        case kCellTypeEdit:
        {
            height = 44.0;
        }
            break;
    }
    return height;
}
- (NSString*) stringForPassColor:(HSPassColor) color
{
    NSString *str = [HS_PASS_COLORS objectAtIndex:color];
    return str;
}

#pragma mark - Picker Methods

- (void) pickerShow:(UIPickerView*) picker
{
    [UIView animateWithDuration:0.3f animations:^{
        [picker setFrame:RECT_PICKER_SHOW];
    }];
}
- (void) pickerHide:(UIPickerView*) picker
{
    [UIView animateWithDuration:0.3f animations:^{
        [picker setFrame:RECT_PICKER_HIDE];
    }];
}

@end
