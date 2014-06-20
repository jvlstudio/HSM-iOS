//
//  HSNetworkSingleViewController.m
//  HSM
//
//  Created by Felipe Ricieri on 16/06/14.
//  Copyright (c) 2014 ikomm Digital Solutions. All rights reserved.
//

#import "HSNetworkSingleViewController.h"

@interface HSNetworkSingleViewController ()
- (void) setConfiguration;
- (void) setDisabled;
- (void) openBlackView;
- (void) closeBlackView;
@end

@implementation HSNetworkSingleViewController
{
    BOOL isBlackViewOpen;
}

@synthesize contact;

#pragma mark - Controller Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setConfiguration];
}

#pragma mark - IBActions

- (IBAction) pressAddContact:(UIButton *)sender
{
    BOOL didAdd = [[HSMaster network] addContactToAddressBook:contact];
    if (!didAdd)
        [[HSMaster tools] dialogWithMessage:@"Não foi possível salvar este contato em sua Agenda."];
    else
    {
        [[HSMaster tools] dialogWithMessage:[NSString stringWithFormat:@"O contato de \"%@\" foi adicionado com sucesso em sua Agenda.", contact.name]];
        [[HSMaster network] setContactAsAdded:contact];
        [self setDisabled];
    }
}
- (IBAction) pressSendEmail:(UIButton *)sender
{
    // get a new new MailComposeViewController object
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    // his class should be the delegate of the mc
    mc.mailComposeDelegate = self;
    // set a mail subject ... but you do not need to do this :)
    [mc setSubject:@"Network HSM"];
    // set some basic plain text as the message body ... but you do not need to do this :)
    [mc setMessageBody:@"Olá," isHTML:NO];
    // set some recipients ... but you do not need to do this :)
    [mc setToRecipients:[NSArray arrayWithObjects:contact.email, nil]];
    // displaying our modal view controller on the screen (of course animated has to be set on YES if you want to see any transition)
    [self presentViewController:mc animated:YES completion:nil];
}
- (IBAction) pressBlack:(UIButton *)sender
{
    if (isBlackViewOpen)
        [self closeBlackView];
    else
        [self openBlackView];
}

#pragma mark Methods

- (void) setConfiguration
{
    [labName setFont:[UIFont fontWithName:FONT_BOLD size:16]];
    [labName2 setFont:[UIFont fontWithName:FONT_BOLD size:16]];
    [labEmail setFont:[UIFont fontWithName:FONT_REGULAR size:12]];
    [labCompany setFont:[UIFont fontWithName:FONT_REGULAR size:12]];
    [labRole setFont:[UIFont fontWithName:FONT_REGULAR size:12]];
    [labPhone setFont:[UIFont fontWithName:FONT_REGULAR size:12]];
    [labMobile setFont:[UIFont fontWithName:FONT_REGULAR size:12]];
    
    [labName setText:contact.name];
    [labName2 setText:contact.name];
    [labEmail setText:contact.email];
    [labCompany setText:contact.company];
    [labRole setText:contact.role];
    [labPhone setText:contact.phone];
    [labMobile setText:contact.mobile];
    
    NSString *strImg    = [NSString stringWithFormat:@"ball_%@.png", contact.barcolor];
    [imgColor setImage:[UIImage imageNamed:strImg]];
    
    NSString *strQRCode = [NSString stringWithFormat:HS_URL_QRCODE, [[HSMaster network] QRCodeEncrypt:contact]];
    [imgQRCode setImageWithURL:[NSURL URLWithString:strQRCode]];
    
    [[butSendEmail titleLabel] setFont:[UIFont fontWithName:FONT_REGULAR size:16.0]];
    
    //[labName alignBottom];
    [labCompany alignTop];
    [labName2 alignBottom];
    
    [blackView setHidden:YES];
    [blackView setAlpha:0];
    isBlackViewOpen = NO;
    
    // ..
    if ([[HSMaster network] hasContactBeenAdd:contact])
        [self setDisabled];
}
- (void) setDisabled
{
    [butAddContact setEnabled:NO];
    [butAddContact setAlpha:0.5];
}
- (void) openBlackView
{
    [blackView setHidden:NO];
    [imgZoom setHidden:YES];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    [UIView animateWithDuration:0.3f animations:^{
        CGRect frame = CGRectMake((WINDOW_WIDTH/2)-125, (WINDOW_HEIGHT/2)-125, 250, 250);
        [imgQRCode setFrame:frame];
        [butBlack setFrame:frame];
        [blackView setAlpha:1];
    } completion:^(BOOL finished) {
        isBlackViewOpen = YES;
    }];
}
- (void) closeBlackView
{
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    [UIView animateWithDuration:0.3f animations:^{
        CGRect frame = CGRectMake(174, 215, 125, 125);
        [imgQRCode setFrame:frame];
        [butBlack setFrame:frame];
        [blackView setAlpha:0];
    } completion:^(BOOL finished) {
        isBlackViewOpen = NO;
        [blackView setHidden:YES];
        [imgZoom setHidden:NO];
    }];
}

#pragma mark - Mail methods

// delegate function callback
- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error
{
    // switchng the result
    switch (result) {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail send canceled.");
            /*
             Execute your code for canceled event here ...
             */
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved.");
            /*
             Execute your code for email saved event here ...
             */
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent.");
            /*
             Execute your code for email sent event here ...
             */
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail send error: %@.", [error localizedDescription]);
            /*
             Execute your code for email send failed event here ...
             */
            break;
        default:
            break;
    }
    // hide the modal view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
