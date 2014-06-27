//
//  HSPassFormAddViewController.m
//  HSM
//
//  Created by Felipe Ricieri on 26/06/14.
//  Copyright (c) 2014 ikomm Digital Solutions. All rights reserved.
//

#import "HSPassFormAddViewController.h"

@interface HSPassFormAddViewController ()
- (void) fillIfHasParticipant;
- (void) textFieldDidEndOnExit:(UITextField *) sender;
- (BOOL) isFormValidToSubmit;
@end

@implementation HSPassFormAddViewController
{
    CGPoint currentOffset;
}

@synthesize pass;
@synthesize indexPath;

#pragma mark - Controller Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark Default Methods

- (void) setConfigurations
{
    [scroll setContentSize:CGSizeMake(scroll.contentSize.width, contentView.frame.size.height+50)];
    [[self view] setBackgroundColor:[UIColor colorWithRed:45.0/255.0 green:45.0/255.0 blue:60.0/255.0 alpha:1]];
    
    [tfName setValue:COLOR_DESCRIPTION forKey:KEY_PLACEHOLDER];
    [tfEmail setValue:COLOR_DESCRIPTION forKey:KEY_PLACEHOLDER];
    [tfCPF setValue:COLOR_DESCRIPTION forKey:KEY_PLACEHOLDER];
    [tfCompany setValue:COLOR_DESCRIPTION forKey:KEY_PLACEHOLDER];
    [tfRole setValue:COLOR_DESCRIPTION forKey:KEY_PLACEHOLDER];
    
    // ...
    // check if participant was touched
    [self fillIfHasParticipant];
}

#pragma mark - IBActions

- (IBAction) pressConfirm:(UIButton *)sender
{
    if ([self isFormValidToSubmit])
    {
        NSMutableDictionary *mutDict = [NSMutableDictionary dictionary];
        [mutDict setObject:[tfName text] forKey:@"name"];
        [mutDict setObject:[tfCompany text] forKey:@"company"];
        [mutDict setObject:[tfEmail text] forKey:@"email"];
        [mutDict setObject:[tfRole text] forKey:@"role"];
        [mutDict setObject:[tfCPF text] forKey:@"cpf"];
        // ...
        [[HSMaster passes] recordParticipant:mutDict atIndexPath:indexPath withColor:pass.color];
        [[self navigationController] popViewControllerAnimated:YES];
    }
    else {
        [[HSMaster tools] dialogWithMessage:@"Por favor, preencha os campos corretamente."];
    }
}
#pragma mark - IBActions

- (IBAction) pressBack:(UIBarButtonItem *)sender
{
    [[self navigationController] popViewControllerAnimated:YES];
}
- (IBAction) textFieldDidEndOnExit:(UITextField *) sender
{
    UITextField *tf = (UITextField*)sender;
    [tf endEditing:YES];
}

#pragma mark - Private Methods

- (void) fillIfHasParticipant
{
    NSDictionary *dict = [[HSMaster passes] rowAtIndexPath:indexPath withColor:pass.color];
    if ([[dict objectForKey:@"subtype"] isEqualToString:@"edit"])
    {
        NSDictionary *values = [dict objectForKey:@"values"];
        [tfName setText:[values objectForKey:@"name"]];
        [tfEmail setText:[values objectForKey:@"email"]];
        [tfCompany setText:[values objectForKey:@"company"]];
        [tfRole setText:[values objectForKey:@"role"]];
        [tfCPF setText:[values objectForKey:@"cpf"]];
    }
}
- (BOOL) isFormValidToSubmit
{
    // check name..
    if ([[tfName text] length] < 3) {
        [[HSMaster tools] dialogWithMessage:@"Por favor, digite o nome do participante."];
        return NO;
    }
    // check email..
    if (![[HSMaster tools] isValidEmail:[tfEmail text]]){
        [[HSMaster tools] dialogWithMessage:@"Por favor, digite um e-mail válido."];
        return NO;
    }
    // check role..
    if ([[tfRole text] length] < 3) {
        [[HSMaster tools] dialogWithMessage:@"Por favor, digite o cargo do participante."];
        return NO;
    }
    // check company..
    if ([[tfCompany text] length] < 3) {
        [[HSMaster tools] dialogWithMessage:@"Por favor, digite a empresa onde o participante trabalha."];
        return NO;
    }
    // check cpf..
    if (![[HSMaster tools] isValidCPF:[tfCPF text]]) {
        [[HSMaster tools] dialogWithMessage:@"Por favor, digite um CPF válido."];
        return NO;
    }
    
    return YES;
}

#pragma mark -
#pragma mark UITextFieldDelegate Methods

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    CGSize rect  = scroll.contentSize;
    rect.height += PICKER_HEIGHT;
    
    [scroll setContentSize:rect];
    [scroll setContentOffset:currentOffset];
}
- (void) textFieldDidEndEditing:(UITextField *)textField
{
    CGSize rect  = scroll.contentSize;
    rect.height -= PICKER_HEIGHT;
    [scroll setContentSize:rect];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    currentOffset = scrollView.contentOffset;
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    currentOffset = scrollView.contentOffset;
}

@end
