//
//  HSEventSingleContentView.h
//  HSM
//
//  Created by Felipe Ricieri on 25/06/14.
//  Copyright (c) 2014 ikomm Digital Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSEventSingleContentView : UIView

@property (nonatomic, weak) IBOutlet UIView *elasticView;
@property (nonatomic, weak) IBOutlet UIImageView *imgCover;
@property (nonatomic, weak) IBOutlet UIImageView *imgBottom;
@property (nonatomic, weak) IBOutlet UIButton *butDates;
@property (nonatomic, weak) IBOutlet UIButton *butContent;

@end
