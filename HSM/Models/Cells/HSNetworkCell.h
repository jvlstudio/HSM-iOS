//
//  HSNetworkCell.h
//  HSM
//
//  Created by Felipe Ricieri on 16/06/14.
//  Copyright (c) 2014 ikomm Digital Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSNetworkCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *labName;
@property (nonatomic, weak) IBOutlet UILabel *labDescription;
@property (nonatomic, weak) IBOutlet UIImageView *imgColor;
@property (nonatomic, weak) IBOutlet UIImageView *imgOpt;

@end
