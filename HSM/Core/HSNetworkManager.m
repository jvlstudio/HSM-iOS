//
//  HSNetworkManager.m
//  HSM
//
//  Created by Felipe Ricieri on 20/06/14.
//  Copyright (c) 2014 ikomm Digital Solutions. All rights reserved.
//

#import "HSNetworkManager.h"

#define LOG_AB_ADDED    @"AbAdded"
#define QRCODE_KEYS     @[@"name", @"email", @"phone", @"mobile", @"company", @"role", @"website", @"barcolor"]

@implementation HSNetworkManager

#pragma mark Methods

- (NSArray *) contacts
{
    NSArray *contacts = [[HSMaster tools] propertyListRead:HS_PLIST_NETWORK];
    return contacts;
}

- (BOOL) isContactAlreadyAdded:(HSContact*) contact
{
    NSArray *arr    = [[HSMaster tools] propertyListRead:HS_PLIST_NETWORK];
    for (NSDictionary *dict in arr)
        if ([[dict objectForKey:@"email"] isEqualToString:contact.email])
            return YES;
    
    return NO;
}

- (void) saveContact:(HSContact *) contact
{
    NSMutableArray *network = [[HSMaster tools] propertyListRead:HS_PLIST_NETWORK];
    [network addObject:contact];
    [[HSMaster tools] propertyListWrite:network forFileName:HS_PLIST_NETWORK];
}
- (void) setContactAsAdded:(HSContact *) contact
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *logKey    = [NSString stringWithFormat:@"%@_%@", LOG_AB_ADDED, contact.email];
    [def setObject:@"yes" forKey:logKey];
    [def synchronize];
}
- (BOOL) hasContactBeenAdd:(HSContact *) contact
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *logKey    = [NSString stringWithFormat:@"%@_%@", LOG_AB_ADDED, contact.email];
    
    if ([[def objectForKey:logKey] isEqualToString:@"yes"])
        return YES;
    else
        return NO;
}
- (void) setSelfCard:(HSContact *) contact
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:contact forKey:@"contact_me"];
    [def synchronize];
}
- (HSContact *) selfCard
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    return [def objectForKey:@"contact_me"];
}
- (BOOL) hasCreatedSelfCard
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    if ([def objectForKey:@"contact_me"])
        return YES;
    else
        return NO;
}

- (BOOL) isValidQRCode:(NSString*) qrcode
{
    NSArray *arr = [[HSMaster tools] explode:qrcode bySeparator:@"-hsm-"];
    if ([arr count] == [QRCODE_KEYS count])
        return YES;
    else
        return NO;
}
- (NSString *) QRCodeEncrypt:(HSContact *) contact
{
    NSMutableArray *arr = [NSMutableArray array];
    
    [arr addObject:contact.name];
    [arr addObject:contact.email];
    [arr addObject:contact.phone];
    [arr addObject:contact.mobile];
    [arr addObject:contact.company];
    [arr addObject:contact.role];
    [arr addObject:contact.website];
    [arr addObject:contact.barcolor];
    
    NSString *strRet = [arr componentsJoinedByString:@"-hsm-"];
    strRet           = [strRet stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"------");
    NSLog(@"[HS_Network] %@", strRet);
    return strRet;
}
- (HSContact *) QRCodeDecrypt:(NSString*) string
{
    NSArray *arr = [[HSMaster tools] explode:string bySeparator:@"-hsm-"];
    NSMutableDictionary *mutDict = [NSMutableDictionary dictionary];
    
    for (uint i=0; i<[arr count]; i++)
        [mutDict setObject:[arr objectAtIndex:i] forKey:[QRCODE_KEYS objectAtIndex:i]];
    
    // contact
    HSContact *contact = [HSContact new];
    contact.name = [mutDict objectForKey:@"name"];
    contact.email = [mutDict objectForKey:@"email"];
    contact.phone = [mutDict objectForKey:@"phone"];
    contact.mobile = [mutDict objectForKey:@"mobile"];
    contact.company = [mutDict objectForKey:@"company"];
    contact.role = [mutDict objectForKey:@"role"];
    contact.website = [mutDict objectForKey:@"website"];
    contact.barcolor = [mutDict objectForKey:@"barcolor"];
    
    return contact;
}

- (BOOL) addContactToAddressBook:(HSContact *) contact
{
    ABAddressBookRef addressBook = ABAddressBookCreate();
    __block BOOL accessGranted   = NO;
    BOOL didAdd = NO;
    
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
        accessGranted = granted;
        dispatch_semaphore_signal(sema);
    });
    
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    
    // can add..
    if (accessGranted)
    {
        NSString *obs       = @"Contato adicionado via cartão virtual da HSM Inspiring Ideas, desenvolvido pela ikomm Digital Solutions.";
        
        // (0) firstname + (1) lastname + (2) company + (3) email + (4) phone
        ABRecordRef person = ABPersonCreate();
        CFErrorRef  error = NULL;
        
        // firstname
        ABRecordSetValue(person, kABPersonFirstNameProperty, (__bridge CFTypeRef)(contact.name), NULL);
        
        // company, role
        ABRecordSetValue(person, kABPersonOrganizationProperty, (__bridge CFTypeRef)(contact.company), NULL);
        ABRecordSetValue(person, kABPersonJobTitleProperty, (__bridge CFTypeRef)(contact.role), NULL);
        
        // email
        ABMutableMultiValueRef abEmail = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        ABMultiValueAddValueAndLabel(abEmail, (__bridge CFTypeRef)(contact.email), CFSTR("email"), NULL);
        ABRecordSetValue(person, kABPersonEmailProperty, abEmail, &error);
        CFRelease(abEmail);
        
        // phone
        ABMutableMultiValueRef abPhone = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        ABMultiValueAddValueAndLabel(abPhone, (__bridge CFTypeRef)(contact.phone), CFSTR("telefone (HSM)"), NULL);
        ABMultiValueAddValueAndLabel(abPhone, (__bridge CFTypeRef)(contact.mobile), CFSTR("celular (HSM)"), NULL);
        ABRecordSetValue(person, kABPersonPhoneProperty, abPhone, &error);
        CFRelease(abPhone);
        
        // note
        ABRecordSetValue(person, kABPersonNoteProperty, (__bridge CFTypeRef)(obs), NULL);
        
        /*
         // add an image !
         UIImage *im = [UIImage imageNamed:@"logo_mobile_48.png"];
         NSData *dataRef = UIImagePNGRepresentation(im);
         ABPersonSetImageData(newPerson, (__bridge CFDataRef)dataRef, nil);*/
        
        ABAddressBookAddRecord(addressBook, person, nil);
        didAdd = ABAddressBookSave(addressBook, nil);
        
        CFRelease(person);
    }
    
    return didAdd;
}

@end
