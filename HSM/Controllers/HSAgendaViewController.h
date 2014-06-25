//
//  HSAgendaViewController.h
//  HSM
//
//  Created by Felipe Ricieri on 16/06/14.
//  Copyright (c) 2014 ikomm Digital Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSEvent.h"
#import "HSLecture.h"

@interface HSAgendaViewController : UITableViewController
{
    HSEvent *event;
    
    NSArray *rows;
    NSArray *agendaDays;
    NSMutableArray *scheduleDays;
    
    IBOutlet UISegmentedControl* segment;
}

@property (nonatomic, strong) HSEvent *event;

#pragma mark - IBActions

- (IBAction) segmentChanged:(UISegmentedControl*)sender;
- (IBAction) pressBack:(UIBarButtonItem *)sender;

@end
