//
//  BaseMessageTableViewCell.h
//  PSWeChat
//
//  Created by 思 彭 on 2017/4/26.
//  Copyright © 2017年 思 彭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Message.h"

/*
 在从重用池出列时，修改的数据会作用到其他具有相同标识的待重用列上，所以需要用到两个标识避免数据错误
 */
static NSString* const kCellIdentifierLeft = @"ChatroomIdentifierLeft";
static NSString* const kCellIdentifierRight = @"ChatroomIdentifierRight";

typedef NS_ENUM(NSUInteger, MessageAlignement) {
    MessageAlignementUndefined,
    MessageAlignementLeft,
    MessageAlignementRight
};

@interface BaseMessageTableViewCell : UITableViewCell

@property (assign, nonatomic) MessageAlignement alignement;
@property (strong, nonatomic) UIImageView *bubbleView;

@property (nonatomic, strong) Message *model;

- (void)buildCell;
- (void)bindConstraints;
- (void)longPressOnBubble:(UILongPressGestureRecognizer*)press;


@end
