//
//  SelectPersonCell.h
//  PSWeChat
//
//  Created by 思 彭 on 2017/5/2.
//  Copyright © 2017年 思 彭. All rights reserved.
//

// 选择通知人员cell

#import <UIKit/UIKit.h>
//#import "FriendModel.h"

/**
 选中button
 */
@protocol SelectPersonCellDelegate <NSObject>

- (void)selectButtonDidClick: (NSIndexPath *)indexPath withButton: (UIButton *)button;

@end

@interface SelectPersonCell : UITableViewCell

@property (nonatomic, strong) UIButton *selectButton;
@property (nonatomic, strong) UIImageView *avaterImgView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic , strong) NSIndexPath *indexPath;
//@property (nonatomic , strong) FriendModel *model;

@property (nonatomic, assign) id<SelectPersonCellDelegate>selectDelegate;

- (void)configureCellWithIsSelected: (BOOL)isSelected
                       avaterImgUrl: (NSString *)imgUrl
                            nameStr: (NSString *)nameStr;

@end
