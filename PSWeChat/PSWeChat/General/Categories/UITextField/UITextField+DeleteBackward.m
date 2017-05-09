//
//  UITextField+DeleteBackward.m
//  PSWeChat
//
//  Created by 思 彭 on 2017/5/2.
//  Copyright © 2017年 思 彭. All rights reserved.
//

#import "UITextField+DeleteBackward.h"
#import <objc/runtime.h>

NSString * const TextFieldDidDeleteBackwardNotification = @"com.textfield.did.notification";

@implementation UITextField (DeleteBackward)

+ (void)load {
    //交换2个方法中的IMP
    Method method1 = class_getInstanceMethod([self class], NSSelectorFromString(@"deleteBackward"));
    Method method2 = class_getInstanceMethod([self class], @selector(ps_deleteBackward));
    method_exchangeImplementations(method1, method2);
}

- (void)ps_deleteBackward {
    [self ps_deleteBackward];
    
    if ([self.delegate respondsToSelector:@selector(textFieldDidDeleteBackward:)]) {
        id <PSTextFieldDelegate> delegate  = (id<PSTextFieldDelegate>)self.delegate;
        [delegate textFieldDidDeleteBackward:self];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:TextFieldDidDeleteBackwardNotification object:self];
}

@end
