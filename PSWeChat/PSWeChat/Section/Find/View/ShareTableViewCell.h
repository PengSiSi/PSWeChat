//
//  ShareTableViewCell.h
//  PSWeChat
//
//  Created by 思 彭 on 2017/4/16.
//  Copyright © 2017年 思 彭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGGView.h"
#import "CommentCell.h"

@class MessageModel;

@interface ShareTableViewCell : UITableViewCell

@property (strong, nonatomic) UIImageView *iconImgV;/**< 头像icon*/
@property (strong, nonatomic) UILabel *nameLabel;/**< 人名label*/
@property (strong, nonatomic) UILabel *contentLabel;/**< 标题label*/
@property (strong, nonatomic) UIButton *moreBtn;/**< 全部、收起按钮*/
@property (strong, nonatomic) UILabel *timeLabel;/**< 时间*/
@property (strong, nonatomic) UIButton *replyButton;/**< 点赞,评论*/
@property (strong, nonatomic) UIButton *deleteButton;/**< 删除*/
@property (strong, nonatomic) UITableView *commentTableView;/**< */

@property (nonatomic, copy) NSIndexPath *indexPath;
@property (nonatomic, strong) MessageModel *messageModel;

/**
 *  更多按钮的block
 */
@property (nonatomic, copy)void(^MoreBtnClickBlock)(UIButton *moreBtn,NSIndexPath * indexPath);

/**
 *  点击图片的block
 */
@property (nonatomic, copy)TapBlcok tapImageBlock;

/**
 *  点击评论按钮的block
 */
@property (nonatomic, copy)void(^ReplyBtnClickBlock)(UIButton *replyBtn,NSIndexPath * indexPath);

/**
 *  点击commentCell的block
 */
@property (nonatomic, copy)void(^commentCellDidSelectBlock)(UITableView *tableView, CommentCell *cell,NSIndexPath * indexPath);

/**
 *  点击删除按钮的block
 */
@property (nonatomic, copy)void(^DeleteBtnClickBlock)(UIButton *deleteBtn,NSIndexPath * indexPath);

- (void)configCellWithModel:(MessageModel *)model indexPath:(NSIndexPath *)indexPath;

@end
