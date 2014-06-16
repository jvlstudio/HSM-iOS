//
//  HSTools.m
//  HSM
//
//  Created by Felipe Ricieri on 16/06/14.
//  Copyright (c) 2014 ikomm Digital Solutions. All rights reserved.
//

#import "HSTools.h"

@implementation HSTools
{
    NSDictionary* globalPlist;
    NSString *rootPath;
    NSString* plistWithRootPath;
}

@synthesize completionYes, completionNo;

#pragma mark - Methods

- (id)   propertyListRead:(NSString*) plistName
{
    NSString *errorDesc = nil;
    NSPropertyListFormat format;
    rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                    NSUserDomainMask, YES) objectAtIndex:0];
    
	NSString *path = [[NSString alloc] initWithFormat:@"%@.plist", plistName];
    plistWithRootPath = [rootPath stringByAppendingPathComponent:path];
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistWithRootPath]) {
        plistWithRootPath = [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
    }
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistWithRootPath];
    NSDictionary *temp = (NSDictionary *)[NSPropertyListSerialization
                                          propertyListFromData:plistXML
                                          mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                          format:&format
                                          errorDescription:&errorDesc];
    if (!temp) {
		NSLog(@"-----");
        NSLog(@"[CH_TOOLS] Erro ao ler PLIST: %@ (format: %u)", errorDesc, format);
    }
    
    return temp;
}
- (BOOL) propertyListWrite:(id) content forFileName:(NSString*) fileName
{
    rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                    NSUserDomainMask, YES) lastObject];
	
	NSString *path = [[NSString alloc] initWithFormat:@"%@.plist", fileName];
    plistWithRootPath = [rootPath stringByAppendingPathComponent:path];
    
    if(content)
    {
        // is array..
        if ([content isKindOfClass:[NSArray class]])
        {
            NSArray *contentArray = (NSArray*)content;
            if([contentArray writeToFile:plistWithRootPath atomically:YES])
                return YES;
            else {
				NSLog(@"-----");
                NSLog(@"[CH_TOOLS]: Erro ao escrever na PLIST: %@", fileName);
                return NO;
            }
        }
        // is dictionary..
        else {
            NSDictionary *contentDict = (NSDictionary*)content;
            if([contentDict writeToFile:plistWithRootPath atomically:YES])
                return YES;
            else {
                NSLog(@"-----");
                NSLog(@"[CH_TOOLS]: Erro ao escrever na PLIST: %@", fileName);
                return NO;
            }
        }
    }
    else {
        NSLog(@"-----");
		NSLog(@"[CH_TOOLS]: Erro ao escrever na PLIST: %@", fileName);
        return NO;
    }
}

- (void) dialogWithMessage:(NSString*) message
{
    [self dialogWithMessage:message cancelButton:nil title:nil];
}
- (void) dialogWithMessage:(NSString*) message cancelButton:(NSString*) cancel
{
    [self dialogWithMessage:message cancelButton:cancel title:nil];
}
- (void) dialogWithMessage:(NSString*) message title:(NSString*) title
{
    [self dialogWithMessage:message cancelButton:nil title:title];
}
- (void) dialogWithMessage:(NSString*) message cancelButton:(NSString*) cancel title:(NSString*) title
{
    NSString *buttonLabel;
    if (!cancel)
        buttonLabel = @"Ok";
    else
        buttonLabel = cancel;
    
	UIAlertView *dialog;
    dialog = [[UIAlertView alloc] initWithTitle:title
										message:message
									   delegate:self
							  cancelButtonTitle:buttonLabel
							  otherButtonTitles:nil, nil];
    [dialog show];
}
- (void) promptWithMessage:(NSString*) message completionYes:(void(^)(void)) compYes completionNo:(void(^)(void)) compNo
{
    completionNo    = compNo;
    completionYes   = compYes;
    
    UIAlertView *dialog;
    dialog = [[UIAlertView alloc] initWithTitle:nil
										message:message
									   delegate:self
							  cancelButtonTitle:@"Não"
							  otherButtonTitles:@"Sim", nil];
    [dialog show];
}
- (void) promptWithMessage:(NSString*) message title:(NSString*)title completionYes:(void(^)(void)) compYes completionNo:(void(^)(void)) compNo
{
    completionNo    = compNo;
    completionYes   = compYes;
    
    UIAlertView *dialog;
    dialog = [[UIAlertView alloc] initWithTitle:nil
										message:message
									   delegate:self
							  cancelButtonTitle:@"Não"
							  otherButtonTitles:@"Sim", nil];
    [dialog show];
}

- (BOOL) isValidEmail:(NSString*) str
{
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:str];
}

#pragma mark - UIAlertViewDelegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    AlertViewOption opt = buttonIndex;
    switch (opt)
    {
        case kOptionNo:
        {
            if (completionNo)
                completionNo();
        }
            break;
        case kOptionYes:
        {
            if (completionYes)
                completionYes();
        }
            break;
    }
}

@end
