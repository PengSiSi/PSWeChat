//
//  AddShareTableViewCell.m
//  PSWeChat
//
//  Created by 思 彭 on 2017/4/19.
//  Copyright © 2017年 思 彭. All rights reserved.
//

#import "AddShareTableViewCell.h"

@interface AddShareTableViewCell ()

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *rightLabel;

@end

@implementation AddShareTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createSubViews];
        [self layOut];
    }
    return self;
}

- (void)createSubViews {
    
    self.imgView = [[UIImageView alloc]init];
    self.imgView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.imgView];
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = FONT_14;
    self.titleLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:self.titleLabel];
    self.rightLabel = [[UILabel alloc]init];
    self.rightLabel.font = FONT_14;
    self.rightLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:self.rightLabel];
}

- (void)layOut {
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(10);
        make.centerY.mas_equalTo(self.contentView);
        make.width.height.mas_equalTo(20);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.imgView.mas_right).offset(10);
        make.centerY.mas_equalTo(self.imgView);
    }];
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView).offset(-10);
        make.centerY.mas_equalTo(self.imgView);
    }];
}

- (void)configureAddShareTableViewCellWithImageName: (NSString *)imageName title: (NSString *)title {
    
    self.imgView.image = [UIImage imageNamed:imageName];
    self.titleLabel.text = title;
    self.rightLabel.text = @"";
}

@end
