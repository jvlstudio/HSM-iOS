//
//  HSPassFormOptionsViewController.h
//  HSM
//
//  Created by Felipe Ricieri on 27/06/14.
//  Copyright (c) 2014 ikomm Digital Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSPass.h"

@interface HSPassFormOptionsViewController : UITableViewController
{
    NSArray *rows;
    NSIndexPath *currentIndexPath;
    HSPassColor passColor;
}

@property (nonatomic, strong) NSArray *rows;
@property (nonatomic, strong) NSIndexPath *currentIndexPath;
@property (nonatomic) HSPassColor passColor;

#pragma mark - Actions

- (IBAction) pressBack:(UIBarButtonItem *)sender;

@end
