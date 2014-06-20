//
//  HSNetworkManager.h
//  HSM
//
//  Created by Felipe Ricieri on 20/06/14.
//  Copyright (c) 2014 ikomm Digital Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
#import "HSContact.h"

@interface HSNetworkManager : NSObject

#pragma mark Methods

- (NSArray *) contacts;

- (BOOL) isContactAlreadyAdded:(HSContact*) contact;

- (void) saveContact:(HSContact *) contact;
- (void) setContactAsAdded:(HSContact *) contact;
- (BOOL) hasContactBeenAdd:(HSContact *) contact;
- (void) setSelfCard:(HSContact *) contact;
- (HSContact *) selfCard;
- (BOOL) hasCreatedSelfCard;

- (BOOL) isValidQRCode:(NSString*) qrcode;
- (NSString *) QRCodeEncrypt:(HSContact *) contact;
- (HSContact *) QRCodeDecrypt:(NSString*) string;

- (BOOL) addContactToAddressBook:(HSContact *) contact;

@end
