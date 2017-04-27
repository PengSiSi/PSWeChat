//
//  EditorView.h
//  PSWeChat
//
//  Created by 思 彭 on 2017/4/27.
//  Copyright © 2017年 思 彭. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ChatMessageType) {
    /* 文本信息 */
    ChatMessageTypeText,
    /* 图片信息 */
    ChatMessageTypeImage,
    /* 语音信息 */
    ChatMessageTypeVoice
};

@interface EditorView : UIView


/**
 单例创建xib加载视图
 @return
 */
+ (instancetype)editorView;


/**
 键盘弹出block
 */
@property (nonatomic, copy) void (^keyBoardWillShow)(NSInteger animCurveKey, CGFloat duration, CGSize keyboardSize);

/**
 键盘隐藏block
 */
@property (nonatomic, copy) void (^keyboardWillHidden) (NSInteger animCurveKey, CGFloat duration, CGSize keyboardSize);

/**
 消息发送block
 */
@property (nonatomic, copy) void (^messageWasSend) (id message, ChatMessageType type);

@property (nonatomic, copy) void (^voiceButtonClick)();
@property (nonatomic, copy) void (^emojButtonClick)();
@property (nonatomic, copy) void (^addButtonClick)();

@end
