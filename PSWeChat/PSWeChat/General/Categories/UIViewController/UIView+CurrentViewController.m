//
//  UIView+CurrentViewController.m
//  ysfx
//
//  Created by 思 彭 on 16/10/14.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "UIView+CurrentViewController.h"

@implementation UIView (CurrentViewController)

-(UIViewController *)getCurrentViewController{
    
    UIResponder *next = [self nextResponder];
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next != nil);
    return nil;
}

@end
