//
//  HomeTableViewCell.m
//  PSWeChat
//
//  Created by 思 彭 on 2017/4/16.
//  Copyright © 2017年 思 彭. All rights reserved.
//

#import "HomeTableViewCell.h"

@interface HomeTableViewCell ()

@end

@implementation HomeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self createSubViews];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createSubViews];
        [self layOut];
        [self testSubViews];
    }
    return self;
}

- (void)createSubViews {
    
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.descriptionLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.avatarImgView];
}

- (void)layOut {
    
    __weak typeof(self) weakSelf = self;
    [self.avatarImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.contentView).offset(NormalSpace);
        make.top.mas_equalTo(weakSelf.contentView).offset(NormalSpace);
        make.width.height.mas_equalTo(40);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.avatarImgView.mas_right).offset(NormalSpace);
        make.top.mas_equalTo(weakSelf.contentView).offset(NormalSpace);
    }];
    [self.descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.avatarImgView.mas_right).offset(NormalSpace);
        make.bottom.mas_equalTo(weakSelf.avatarImgView);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.contentView).offset(-NormalSpace);
        make.top.mas_equalTo(weakSelf.contentView).offset(NormalSpace);
    }];
}

- (void)testSubViews {
    
}

#pragma mark - 懒加载

- (UIImageView *)avatarImgView {
    
    if (!_avatarImgView) {
        _avatarImgView = [[UIImageView alloc]init];
        _avatarImgView.contentMode = UIViewContentModeScaleAspectFill;
        _avatarImgView.clipsToBounds = YES;
        _avatarImgView.layer.cornerRadius = 3.0f;
    }
    return _avatarImgView;
}

- (UILabel *)nameLabel {
    
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.font = FONT_15;
    }
    return _nameLabel;
}

- (UILabel *)descriptionLabel {
    
    if (!_descriptionLabel) {
        _descriptionLabel = [[UILabel alloc]init];
        _descriptionLabel.font = FONT_14;
        _descriptionLabel.textColor = [UIColor lightGrayColor];
    }
    return _descriptionLabel;
}

- (UILabel *)timeLabel {
    
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.font = FONT_13;
        _timeLabel.textColor = [UIColor lightGrayColor];
    }
    return _timeLabel;
}

@end
