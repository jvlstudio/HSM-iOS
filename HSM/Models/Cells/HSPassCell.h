//
//  HSPassCell.h
//  HSM
//
//  Created by Felipe Ricieri on 16/06/14.
//  Copyright (c) 2014 ikomm Digital Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSPassCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *imgBackground;
@property (nonatomic, weak) IBOutlet UILabel *labTitle;
@property (nonatomic, weak) IBOutlet UILabel *labDescription;
@property (nonatomic, weak) IBOutlet UILabel *labValidto;
@property (nonatomic, weak) IBOutlet UILabel *labValue;
@property (nonatomic, weak) IBOutlet UILabel *labValuePromo;

@end
