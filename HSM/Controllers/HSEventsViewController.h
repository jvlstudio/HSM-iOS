//
//  HSEventsViewController.h
//  HSM
//
//  Created by Felipe Ricieri on 16/06/14.
//  Copyright (c) 2014 ikomm Digital Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSEvent.h"

@interface HSEventsViewController : UITableViewController
{
    NSArray *rows;
    HSEvent *selectedEvent;
    IBOutlet UISegmentedControl *segment;
}

#pragma mark - IBActions

- (IBAction) changedValue:(UISegmentedControl*)sender;

@end
