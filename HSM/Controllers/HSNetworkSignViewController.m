//
//  HSNetworkSignViewController.m
//  HSM
//
//  Created by Felipe Ricieri on 23/06/14.
//  Copyright (c) 2014 ikomm Digital Solutions. All rights reserved.
//

#import "HSNetworkSignViewController.h"
#import "HSContact.h"

@interface HSNetworkSignViewController ()

@end

@implementation HSNetworkSignViewController
{
    CGPoint currentOffset;
}

#pragma mark - Controller Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - IBActions

- (IBAction) doneEditing:(id)sender
{
    UITextField *tf = (UITextField*) sender;
    [tf endEditing:YES];
}
- (IBAction) pressCreate:(id)sender
{
    // ...
    if (![[HSMaster tools] isValidEmail:[tfEmail text]])
        [[HSMaster tools] dialogWithMessage:@"Por favor, insira um e-mail válido."];
    // ...
    else if ([[tfName text] length] < 3)
        [[HSMaster tools] dialogWithMessage:@"Por favor, insira seu nome."];
    // ...
    else
    {
        actsheet = [[UIActionSheet alloc] initWithTitle:@"Qual é a cor do seu passe?" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Verde", @"Dourado", @"Vermelho", nil];
        [actsheet showInView:[self view]];
    }
}

#pragma mark - UIScrollViewDelegate Methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    currentOffset = scroll.contentOffset;
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    currentOffset = scroll.contentOffset;
}

#pragma mark - UITextFieldDelegate Methods

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [scroll setContentOffset:currentOffset];
    //[scroll setContentSize:CGSizeMake(scroll.contentSize.width, scroll.contentSize.height+KEYBOARD_HEIGHT)];
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    //[scroll setContentSize:CGSizeMake(scroll.contentSize.width, scroll.contentSize.height-KEYBOARD_HEIGHT)];
}

#pragma mark - UIActionSheetDelegate Methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    HSPassColor colorPass = buttonIndex;
    HSContact *myContact = [HSContact new];
    myContact.name = tfName.text;
    myContact.email = tfEmail.text;
    myContact.phone = tfPhone.text;
    myContact.mobile = tfMobile.text;
    myContact.company = tfCompany.text;
    myContact.role = tfRole.text;
    myContact.website = tfWebsite.text;
    
    switch (colorPass)
    {
        // green
        case kColorGreen:
            myContact.barcolor = @"green";
            break;
        // gold
        case kColorGold:
            myContact.barcolor = @"gold";
            break;
        // red
        case kColorRed:
            myContact.barcolor = @"red";
            break;
    }
    
    [[HSMaster network] setSelfCard:myContact];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
