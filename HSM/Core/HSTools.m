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
- (BOOL) isValidCPF:(NSString*) str
{
    NSUInteger i, firstSum, secondSum, firstDigit, secondDigit, firstDigitCheck, secondDigitCheck;
    if(str == nil) return NO;
    
    if ([str length] != 11) return NO;
    
    if (([str isEqual:@"00000000000"])
        || ([str isEqual:@"11111111111"])
        || ([str isEqual:@"22222222222"])
        || ([str isEqual:@"33333333333"])
        || ([str isEqual:@"44444444444"])
        || ([str isEqual:@"55555555555"])
        || ([str isEqual:@"66666666666"])
        || ([str isEqual:@"77777777777"])
        || ([str isEqual:@"88888888888"])
        || ([str isEqual:@"99999999999"])) return NO;
    
    firstSum = 0;
    for (i = 0; i <= 8; i++) {
        firstSum += [[str substringWithRange:NSMakeRange(i, 1)] intValue] * (10 - i);
    }
    
    if (firstSum % 11 < 2)
        firstDigit = 0;
    else
        firstDigit = 11 - (firstSum % 11);
    
    secondSum = 0;
    for (i = 0; i <= 9; i++) {
        secondSum = secondSum + [[str substringWithRange:NSMakeRange(i, 1)] intValue] * (11 - i);
    }
    
    if (secondSum % 11 < 2)
        secondDigit = 0;
    else
        secondDigit = 11 - (secondSum % 11);
    
    firstDigitCheck = [[str substringWithRange:NSMakeRange(9, 1)] intValue];
    secondDigitCheck = [[str substringWithRange:NSMakeRange(10, 1)] intValue];
    
    if ((firstDigit == firstDigitCheck) && (secondDigit == secondDigitCheck))
        return YES;
    return NO;
}
- (BOOL) isValidCNPJ:(NSString*) str
{
    NSUInteger i, tamanho, soma, pos, resultado;
    NSString *numeros, *digitos;
    
    if (str == nil) return NO;
    if ([str length] != 14) return NO;
    
    if (([str isEqual:@"00000000000"])
        || ([str isEqual:@"11111111111"])
        || ([str isEqual:@"22222222222"])
        || ([str isEqual:@"33333333333"])
        || ([str isEqual:@"44444444444"])
        || ([str isEqual:@"55555555555"])
        || ([str isEqual:@"66666666666"])
        || ([str isEqual:@"77777777777"])
        || ([str isEqual:@"88888888888"])
        || ([str isEqual:@"99999999999"])) return NO;
    
    // Valida DVs
    tamanho = str.length - 2;
    numeros = [str substringWithRange:NSMakeRange(0, tamanho)];
    digitos = [str substringWithRange:NSMakeRange(tamanho, 2)];
    soma    = 0;
    pos     = tamanho - 7;
    
    for (i = tamanho; i >= 1; i--)
    {
        soma += [numeros characterAtIndex:(tamanho - i)] * pos--;
        if (pos < 2)
            pos = 9;
    }
    
    resultado = soma % 11 < 2 ? 0 : 11 - soma % 11;
    if (resultado != [digitos characterAtIndex:0])
        return false;
    
    tamanho = tamanho + 1;
    numeros = [str substringWithRange:NSMakeRange(0, tamanho)];
    soma    = 0;
    pos     = tamanho - 7;
    
    for (i = tamanho; i >= 1; i--)
    {
        soma += [numeros characterAtIndex:(tamanho - i)] * pos--;
        if (pos < 2)
            pos = 9;
    }
    
    resultado = soma % 11 < 2 ? 0 : 11 - soma % 11;
    if (resultado != [digitos characterAtIndex:1])
        return false;
    
    return true;
}

- (NSArray*) explode: (NSString*) string bySeparator:(NSString*)separator
{
    NSArray* x = [string componentsSeparatedByString:separator];
    return x;
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
