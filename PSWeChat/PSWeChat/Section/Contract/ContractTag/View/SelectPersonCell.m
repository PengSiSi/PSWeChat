//
//  SelectPersonCell.m
//  PSWeChat
//
//  Created by 思 彭 on 2017/5/2.
//  Copyright © 2017年 思 彭. All rights reserved.
//

#import "SelectPersonCell.h"

@implementation SelectPersonCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle: style reuseIdentifier:reuseIdentifier]) {
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    
    self.selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.selectButton addTarget:self action:@selector(selectBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.selectButton];
    
    self.avaterImgView = [[UIImageView alloc]init];
    [self.contentView addSubview:self.avaterImgView];
    self.avaterImgView.layer.cornerRadius = 5.0f;
    self.avaterImgView.layer.masksToBounds = YES;
    
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.font = FONT_16;
    [self.contentView addSubview:self.nameLabel];
    [self layOut];
}

- (void)layOut {
    
    __weak typeof(self) weakSelf = self;
    
    [self.selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(weakSelf.contentView).offset(NormalSpace);
        make.centerY.mas_equalTo(weakSelf.contentView);
        make.width.height.mas_equalTo(20);
        
    }];
    [self.avaterImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.selectButton.mas_right).offset(NormalSpace);
        make.centerY.mas_equalTo(weakSelf.contentView);
        make.width.height.mas_equalTo(40);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.avaterImgView.mas_right).offset(NormalSpace);
        make.centerY.mas_equalTo(weakSelf.contentView);
    }];
}

- (void)configureCellWithIsSelected: (BOOL)isSelected avaterImgUrl: (NSString *)imgUrl nameStr: (NSString *)nameStr {
    
    if (!isSelected) {  // 非选
        [self.selectButton setImage:[UIImage imageNamed:@"album_cb_false"] forState:UIControlStateNormal];
    } else {  // 选择
        [self.selectButton setImage:[UIImage imageNamed:@"f_s_album_choose_icon"] forState:UIControlStateNormal];
    }
    if ([imgUrl hasPrefix:@"http"]) {
        [self.avaterImgView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"contacts_groupinfo_avator_default"]];
    } else {
        self.avaterImgView.image = [UIImage imageNamed:imgUrl];
    }
    self.nameLabel.text = nameStr;
}

//- (void)setModel:(FriendModel *)model {
//    
//    _model = model;
//    if ([model.photo hasPrefix:@"http"]) {
//        [self.avaterImgView sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:[UIImage imageNamed:@"contacts_groupinfo_avator_default"]];
//    } else {
//        self.avaterImgView.image = [UIImage imageNamed:model.photo];
//    }
//    self.nameLabel.text = model.userName;
//
//}

#pragma mark - 选择按钮的代理实现

- (void)selectBtnDidClick:(UIButton *)sender {
    
    if (self.selectDelegate && [self.selectDelegate respondsToSelector:@selector(selectButtonDidClick:withButton:)]) {
        [self.selectDelegate selectButtonDidClick:self.indexPath withButton:sender];
    }
}

@end
