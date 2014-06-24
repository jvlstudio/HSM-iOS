//
//  HSAgendaViewController.h
//  HSM
//
//  Created by Felipe Ricieri on 16/06/14.
//  Copyright (c) 2014 ikomm Digital Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSEvent.h"

@interface HSAgendaViewController : UITableViewController
{
    HSEvent *event;
}

@property (nonatomic, strong) HSEvent *event;

@end
