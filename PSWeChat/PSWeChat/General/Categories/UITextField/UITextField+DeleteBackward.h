//
//  UITextField+DeleteBackward.h
//  PSWeChat
//
//  Created by 思 彭 on 2017/5/2.
//  Copyright © 2017年 思 彭. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PSTextFieldDelegate <UITextFieldDelegate>

@optional

- (void)textFieldDidDeleteBackward:(UITextField *)textField;

@end

@interface UITextField (DeleteBackward)

@property (nonatomic, weak) id<PSTextFieldDelegate> delegate;

/**
 *  监听删除按钮
 *  object:UITextField
 */
extern NSString * const TextFieldDidDeleteBackwardNotification;

@end
