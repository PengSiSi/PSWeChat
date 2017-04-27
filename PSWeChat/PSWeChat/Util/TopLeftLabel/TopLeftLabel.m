//
//  TopLeftLabel.m
//  Donghuamen
//
//  Created by 思 彭 on 17/1/3.
//  Copyright © 2017年 Combanc. All rights reserved.
//

#import "TopLeftLabel.h"

@implementation TopLeftLabel

- (id)initWithFrame:(CGRect)frame {
    
    return [super initWithFrame:frame];
}
- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
    
    CGRect textRect = [super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
    textRect.origin.y = bounds.origin.y;
    return textRect;
}
- (void)drawTextInRect:(CGRect)requestedRect {
    
    CGRect actualRect = [self textRectForBounds:requestedRect limitedToNumberOfLines:self.numberOfLines];
    [super drawTextInRect:actualRect];
}

@end
