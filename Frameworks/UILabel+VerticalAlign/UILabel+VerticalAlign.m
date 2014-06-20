//
//  UILabel+VerticalAlign.m
//  CBM
//
//  Created by Felipe Ricieri on 26/06/13.
//  Copyright (c) 2013 ikomm Digital Solutions. All rights reserved.
//

#import "UILabel+VerticalAlign.h"

@implementation UILabel (VerticalAlign)

- (void) alignTop
{
    CGSize fontSize = [[self text] sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:self.font.pointSize]}];
    
    double finalHeight = fontSize.height * self.numberOfLines;
    double finalWidth = self.frame.size.width;    //expected width of label
    
    NSAttributedString *fontAttr;
    fontAttr        = [[NSAttributedString alloc] initWithString:self.text
                                                      attributes:@{ NSFontAttributeName: self.font}];
    CGRect rect     = [fontAttr boundingRectWithSize:(CGSize){finalWidth, finalHeight}
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                             context:nil];
    CGSize theStringSize = rect.size;
    int newLinesToPad = (finalHeight  - theStringSize.height) / fontSize.height;
    
    // calculate ...
    for(int i=0; i<newLinesToPad; i++)
        self.text = [self.text stringByAppendingString:@"\n "];
}

- (void) alignBottom
{
    CGSize fontSize = [[self text] sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:self.font.pointSize]}];
    
    double finalHeight = fontSize.height * self.numberOfLines;
    double finalWidth = self.frame.size.width;    //expected width of label
    
    NSAttributedString *fontAttr;
    fontAttr        = [[NSAttributedString alloc] initWithString:self.text
                                                      attributes:@{ NSFontAttributeName: self.font}];
    CGRect rect     = [fontAttr boundingRectWithSize:(CGSize){finalWidth, finalHeight}
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                             context:nil];
    CGSize theStringSize = rect.size;
    
    // calculate ...
    int newLinesToPad = (finalHeight  - theStringSize.height) / fontSize.height;
    for(int i=0; i<newLinesToPad; i++)
        self.text = [NSString stringWithFormat:@" \n%@",self.text];
}

@end