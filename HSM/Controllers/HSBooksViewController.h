//
//  HSBooksViewController.h
//  HSM
//
//  Created by Felipe Ricieri on 16/06/14.
//  Copyright (c) 2014 ikomm Digital Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSBook.h"

@interface HSBooksViewController : UITableViewController
{
    NSArray *rows;
    HSBook *selectedBook;
}

@end
