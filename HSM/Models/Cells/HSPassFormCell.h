//
//  HSPassFormCell.h
//  HSM
//
//  Created by Felipe Ricieri on 26/06/14.
//  Copyright (c) 2014 ikomm Digital Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSPassFormCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *labText;
@property (nonatomic, strong) IBOutlet UITextField *tfName;
@property (nonatomic, strong) IBOutlet UITextField *tfEmail;
@property (nonatomic, strong) IBOutlet UITextField *tfCompany;
@property (nonatomic, strong) IBOutlet UITextField *tfRole;

@end
