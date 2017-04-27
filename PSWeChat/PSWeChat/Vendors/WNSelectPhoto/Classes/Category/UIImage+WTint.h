//
//  UIImage+WTint.h
//  WNSelectPhoto
//
//  Created by 王楠 on 15/5/20.
//  Copyright (c) 2015年 王楠. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (WTint)
- (UIImage *) imageWithTintColor:(UIColor *)tintColor;
- (UIImage *) imageWithGradientTintColor:(UIColor *)tintColor;

@end
