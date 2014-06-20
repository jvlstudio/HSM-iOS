//
//  HSEventCell.h
//  HSM
//
//  Created by Felipe Ricieri on 16/06/14.
//  Copyright (c) 2014 ikomm Digital Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSEventCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *imgBackground;
@property (nonatomic, weak) IBOutlet UILabel *labTitle;
@property (nonatomic, weak) IBOutlet UILabel *labSubtitle;
@property (nonatomic, weak) IBOutlet UILabel *labLocal;
@property (nonatomic, weak) IBOutlet UILabel *labDates;

@end
