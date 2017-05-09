//
//  ItemCollectionViewCell.m
//  PSWeChat
//
//  Created by 思 彭 on 2017/5/9.
//  Copyright © 2017年 思 彭. All rights reserved.
//

#import "ItemCollectionViewCell.h"

@interface ItemCollectionViewCell ()

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *textLabel;


@end

@implementation ItemCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        [self layoutUI];
        [self testUI];
    }
    return self;
}

- (void)setupUI {
    
    self.imgView = [[UIImageView alloc]init];
    self.imgView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.imgView];
    self.textLabel = [[UILabel alloc]init];
    self.textLabel.font = FONT_13;
    self.textLabel.textColor = [UIColor lightGrayColor];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.textLabel];
}

- (void)layoutUI {
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(50);
        make.centerX.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.contentView).offset(10);
    }];
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.imgView);
        make.bottom.mas_equalTo(self.contentView).offset(-5);
        make.height.mas_equalTo(15);
    }];
}

- (void)testUI {
    
    self.imgView.backgroundColor = [UIColor redColor];
    self.textLabel.backgroundColor = [UIColor blueColor];
    self.textLabel.text = @"拍视频";
}

@end
