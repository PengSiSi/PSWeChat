//
//  LabelTableViewCell.m
//  PSWeChat
//
//  Created by 思 彭 on 2017/4/19.
//  Copyright © 2017年 思 彭. All rights reserved.

// 左边label,右边label的类型的Cell

#import "LabelTableViewCell.h"

@interface LabelTableViewCell ()

@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *rightLabel;

@end

@implementation LabelTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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
    
    self.rightLabel = [[UILabel alloc]init];
    self.rightLabel.font = FONT_14;
    self.rightLabel.textColor = [UIColor lightGrayColor];
    self.rightLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.rightLabel];
}

- (void)layOut {
    
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView).offset(10);
    }];
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView).offset(-10);
        make.centerY.mas_equalTo(self.contentView);
        make.width.mas_equalTo(100);
    }];
}

- (void)configureLeftLabelText: (NSString *)leftLabelText rightLabeltext: (NSString *)rightLabeltext {
    
    self.leftLabel.text = leftLabelText;
    self.rightLabel.text = rightLabeltext;
}

@end
