//
//  HSPassFormAddViewController.m
//  HSM
//
//  Created by Felipe Ricieri on 26/06/14.
//  Copyright (c) 2014 ikomm Digital Solutions. All rights reserved.
//

#import "HSPassFormViewController.h"
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

@synthesize indexPath;

#pragma mark - Controller Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark Default Methods

- (void) setConfigurations
{
    [scr setContentSize:CGSizeMake(scr.contentSize.width, v.frame.size.height+50)];
    [[self view] setBackgroundColor:[UIColor colorWithRed:45.0/255.0 green:45.0/255.0 blue:60.0/255.0 alpha:1]];
    
    // set delegate ..
    NSArray *subviews = [v subviews];
    for (UIView *vs in subviews)
    {
        if ([vs isKindOfClass:[UITextField class]])
        {
            UITextField *tf = (UITextField*)vs;
            [tf setDelegate:self];
            [tf addTarget:self action:@selector(textFieldDidEndOnExit:) forControlEvents:UIControlEventEditingDidEnd];
            [tf addTarget:self action:@selector(textFieldDidEndOnExit:) forControlEvents:UIControlEventEditingDidEndOnExit];
            [tf setValue:COLOR_DESCRIPTION forKeyPath:@"_placeholderLabel.textColor"];
        }
    }
    
    // ...
    // check if participant was touched
    [self fillIfHasParticipant];
}

#pragma mark - IBActions

- (IBAction) pressConfirm:(id)sender
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
        [HSPassFormViewController recordParticipant:mutDict atIndexPath:indexPath];
        [[self navigationController] popViewControllerAnimated:YES];
    }
    else {
        [[HSMaster tools] dialogWithMessage:@"Por favor, preencha os campos corretamente."];
    }
}

#pragma mark - Private Methods

- (void) fillIfHasParticipant
{
    NSDictionary *dict = [HSPassFormViewController rowAtIndexPath:indexPath];
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
    CGSize rect  = scr.contentSize;
    rect.height += PICKER_HEIGHT;
    
    [scr setContentSize:rect];
    [scr setContentOffset:currentOffset];
}
- (void) textFieldDidEndEditing:(UITextField *)textField
{
    CGSize rect  = scr.contentSize;
    rect.height -= PICKER_HEIGHT;
    [scr setContentSize:rect];
}
- (void) textFieldDidEndOnExit:(UITextField *) sender
{
    UITextField *tf = (UITextField*)sender;
    [tf endEditing:YES];
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
