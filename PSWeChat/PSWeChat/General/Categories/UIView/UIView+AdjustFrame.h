//
//  UIView+AdjustFrame.h
//
//  Created by Mike on 15/4/10.
//  Copyright © 2015年 Mike. All rights reserved.

#import <UIKit/UIKit.h>

@interface UIView (AdjustFrame)

@property (readonly) CGPoint bottomLeft;
@property (readonly) CGPoint bottomRight;
@property (readonly) CGPoint topRight;

@property CGFloat top;
@property CGFloat left;
@property CGFloat bottom;
@property CGFloat right;

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;

@end

@interface UIScrollView (AdjustInsets)

@property (nonatomic, assign) CGFloat contentInsetTop;
@property (nonatomic, assign) CGFloat contentInsetLeft;
@property (nonatomic, assign) CGFloat contentInsetBottom;
@property (nonatomic, assign) CGFloat contentInsetRight;

- (void) moveBy: (CGPoint) delta;
- (void) scaleBy: (CGFloat) scaleFactor;
- (void) fitInSize: (CGSize) aSize;

@end
