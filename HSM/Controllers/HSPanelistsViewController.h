//
//  HSPanelistsViewController.h
//  HSM
//
//  Created by Felipe Ricieri on 16/06/14.
//  Copyright (c) 2014 ikomm Digital Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSPanelistsViewController : UITableViewController
{
    HSEvent *event;
    NSArray *rows;
}

@property (nonatomic, strong) HSEvent *event;

#pragma mark - Actions

- (void) pressBack:(UIBarButtonItem *) sender;

@end
