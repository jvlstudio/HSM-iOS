//
//  HSBookSingleViewController.h
//  HSM
//
//  Created by Felipe Ricieri on 16/06/14.
//  Copyright (c) 2014 ikomm Digital Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSBook.h"

@interface HSBookSingleViewController : UIViewController
{
    HSBook *book;

    IBOutlet UIView *vEspec;
    IBOutlet UIView *vAuthor;
    IBOutlet UIView *vDescription;
    IBOutlet UIScrollView *scroll;
    IBOutlet UIScrollView *scrollSub;
    
    IBOutlet UILabel *labTitle;
    IBOutlet UILabel *labSubtitle;
    IBOutlet UILabel *labPrice;
    IBOutlet UILabel *labAuthor;
    IBOutlet UILabel *labEspecDimensions;
    IBOutlet UILabel *labEspecPages;
    IBOutlet UILabel *labEspecCodebarBook;
    IBOutlet UILabel *labEspecCodebarEBook;
    
    IBOutlet UIButton *butBuy;
    IBOutlet UISegmentedControl *segment;
    IBOutlet UIImageView *imgPicture;
    
    IBOutlet UITextView *tvSinopse;
    IBOutlet UITextView *tvAuthor;
}

@property (nonatomic, strong) HSBook *book;

#pragma mark - IBActions

- (IBAction) pressBuy:(id)sender;
- (IBAction) segmentChange:(UISegmentedControl*)sender;

@end
