//
//  LeftLabelAndRightImgViewCell.m
//  PSWeChat
//
//  Created by 思 彭 on 2017/4/19.
//  Copyright © 2017年 思 彭. All rights reserved.

// 左边label,右边imageView类型的Cell

#import "LeftLabelAndRightImgViewCell.h"

@interface LeftLabelAndRightImgViewCell ()

@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UIImageView *rightImgView;

@end

@implementation LeftLabelAndRightImgViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self createSubViews];
        [self layOut];
    }
    return self;
}

- (void)createSubViews {
    
    self.leftLabel = [[UILabel alloc]init];
    self.leftLabel.font = FONT_14;
    self.leftLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:self.leftLabel];
    self.rightImgView = [[UIImageView alloc]init];
    self.rightImgView.contentMode = UIViewContentModeScaleToFill;
    [self.contentView addSubview:self.rightImgView];
}

- (void)layOut {
    
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView).offset(10);
    }];
    [self.rightImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView).offset(-10);
        make.centerY.mas_equalTo(self.contentView);
        make.width.height.mas_equalTo(self.contentView.mas_height).offset(-10);
    }];
}

- (void)configureLabelText: (NSString *)text imageName: (NSString *)imageName {
    
    self.leftLabel.text = text;
    self.rightImgView.image = [UIImage imageNamed:imageName];
}

@end
