//
//  HSBookCell.h
//  HSM
//
//  Created by Felipe Ricieri on 16/06/14.
//  Copyright (c) 2014 ikomm Digital Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSBookCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *imgPicture;
@property (nonatomic, weak) IBOutlet UILabel *labTitle;
@property (nonatomic, weak) IBOutlet UILabel *labSubtitle;

@end
