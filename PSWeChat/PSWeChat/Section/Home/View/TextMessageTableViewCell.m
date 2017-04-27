//
//  TextMessageTableViewCell.m
//  PSWeChat
//
//  Created by 思 彭 on 2017/4/26.
//  Copyright © 2017年 思 彭. All rights reserved.
//

#import "TextMessageTableViewCell.h"
#import <TTTAttributedLabel.h>

static UIFont* textFont;

@interface TextMessageTableViewCell ()

@property (strong, nonatomic) TTTAttributedLabel* messageLabel;

@end

@implementation TextMessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

+ (void)initialize
{
    textFont = [UIFont systemFontOfSize:16];
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString*)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    }
    return self;
}

- (void)buildCell
{
    [super buildCell];
    
    self.messageLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
    self.messageLabel.text = @"思思好呀!!";
    self.messageLabel.backgroundColor = [UIColor clearColor];
    self.messageLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentTop;
    self.messageLabel.font = textFont;
    self.messageLabel.numberOfLines = 0;
    [super.bubbleView addSubview:self.messageLabel];
}

- (void)bindConstraints
{
    [super bindConstraints];
    
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.edges.insets(UIEdgeInsetsMake(13, 20, 20, 20));
    }];
    [self.messageLabel setContentHuggingPriority:1000 forAxis:UILayoutConstraintAxisVertical];
}

// 注意,这里不需要再定义model,直接使用父类的model即可,否则会报错!
- (void)setModel:(Message *)model {
    
    self.messageLabel.text = model.message;
    
    // 调用父类,修改布局约束
    [super setModel:model];
}

#pragma mark - longpress on bubble

- (void)longPressOnBubble:(UILongPressGestureRecognizer*)press
{
    if (press.state == UIGestureRecognizerStateBegan) {
        [self becomeFirstResponder];
        super.bubbleView.highlighted = YES;
        UIMenuItem* copy =
        [[UIMenuItem alloc] initWithTitle:@"复制"
                                   action:@selector(menuCopy:)];
        UIMenuItem* remove =
        [[UIMenuItem alloc] initWithTitle:@"删除"
                                   action:@selector(menuRemove:)];
        UIMenuController* menu = [UIMenuController sharedMenuController];
        [menu setMenuItems:@[ copy, remove ]];
        [menu setTargetRect:super.bubbleView.frame inView:self];
        [menu setMenuVisible:YES animated:YES];
        
        // 接收UIMenuController隐藏的通知
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(UIMenuControllerWillHideMenu)
         name:UIMenuControllerWillHideMenuNotification
         object:nil];
    }
}

#pragma mark - Private Method

- (void)UIMenuControllerWillHideMenu {
    
    super.bubbleView.highlighted = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    
    return (action == @selector(menuCopy:) || action == @selector(menuRemove:));
}

- (void)menuCopy:(id)sender {
    [UIPasteboard generalPasteboard].string = self.messageLabel.text;
}

- (void)menuRemove:(id)sender {
    
}


@end
