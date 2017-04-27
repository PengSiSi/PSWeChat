//
//  ZanCell.m
//  PSWeChat
//
//  Created by 思 彭 on 2017/4/17.
//  Copyright © 2017年 思 彭. All rights reserved.
//

#import "ZanCell.h"
#import "TopLeftLabel.h"

@interface ZanCell ()

@property (nonatomic, strong) UIImageView *zanImgView;
@property (nonatomic, strong) TopLeftLabel *zanUserLabel;
@property (nonatomic, strong) UIView *grayView;
@property (nonatomic, strong) UIImageView *zanContainerView;

@end

@implementation ZanCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
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

    self.zanContainerView = [[UIImageView alloc]init];
    UIImage *image = [UIImage imageNamed:@"share_likeCmtBg"];
    
    // 图片的拉伸
    self.zanContainerView.image = [image stretchableImageWithLeftCapWidth:image.size.width - 1 topCapHeight:image.size.height / 2];
    [self.contentView addSubview:self.zanContainerView];
    
    self.zanImgView = [[UIImageView alloc]init];
    UIImage *img = [UIImage imageNamed:@"f_application_hs_share_praise_icon_pressed"];
    self.zanImgView.image = img;
    
    // 默认先隐藏
    self.zanImgView.hidden = YES;
    [self.zanContainerView addSubview:self.zanImgView];
    self.zanUserLabel = [[TopLeftLabel alloc]init];
    self.zanUserLabel.font = FONT_14;
    self.zanUserLabel.numberOfLines = 0;
    self.zanUserLabel.textAlignment = NSTextAlignmentCenter;
    self.zanUserLabel.textColor = [UIColor lightGrayColor];
    [self.zanContainerView addSubview:self.zanUserLabel];
}

- (void)layOut {
    
    [self.zanContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
    [self.zanImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.zanContainerView).offset(10);
        make.top.mas_equalTo(self.zanContainerView).offset(10);
        make.width.height.mas_equalTo(20);
    }];
    [self.zanUserLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.zanImgView.mas_right).offset(5);
        make.top.mas_equalTo(self.zanContainerView).offset(10);
        make.bottom.mas_equalTo(self.zanContainerView).offset(-10);
    }];
}

- (void)configureWithZanUser: (NSString *)zanUser {
    
    if (zanUser.length > 0) {
        self.zanImgView.hidden = NO;
    } else {
        self.zanImgView.hidden = YES;
    }
    self.zanUserLabel.text = zanUser;
}

@end
