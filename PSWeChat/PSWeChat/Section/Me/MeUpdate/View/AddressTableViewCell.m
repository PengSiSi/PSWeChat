//
//  AddressTableViewCell.m
//  PSWeChat
//
//  Created by 思 彭 on 2017/4/19.
//  Copyright © 2017年 思 彭. All rights reserved.
//

#import "AddressTableViewCell.h"

@interface AddressTableViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation AddressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createSubViews];
        [self layOut];
    }
    return self;
}

- (void)createSubViews {
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = FONT_14;
    self.titleLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:self.titleLabel];
    
    self.contentLabel = [[UILabel alloc]init];
    self.contentLabel.font = FONT_14;
    self.contentLabel.textColor = [UIColor lightGrayColor];
    self.contentLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.contentLabel];
}

- (void)layOut {
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(10);
        make.left.mas_equalTo(self.contentView).offset(10);
        make.right.mas_equalTo(self.contentView).offset(-10);
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(5);
        make.right.mas_equalTo(self.titleLabel);
        make.bottom.mas_equalTo(self.contentView).offset(-10);
    }];
}

- (void)configureCellWithTitleText: (NSString *)titleText subTitleText: (NSString *)subText {
    
    self.titleLabel.text = titleText;
    self.contentLabel.text = subText;
}

@end
