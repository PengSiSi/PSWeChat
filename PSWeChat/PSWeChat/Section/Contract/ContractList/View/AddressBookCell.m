//
//  AddressBookCell.m
//  PSWeChat
//
//  Created by 思 彭 on 2017/4/17.
//  Copyright © 2017年 思 彭. All rights reserved.
//

#import "AddressBookCell.h"
#import <UIImageView+WebCache.h>

@interface AddressBookCell ()

@end

@implementation AddressBookCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createSubViews];
        [self layOut];
    }
    return self;
}

- (void)createSubViews {
    
    self.iconImgView = [[UIImageView alloc]init];
    // 此模式是拉伸填充,可能会变形
    self.iconImgView.contentMode = UIViewContentModeScaleToFill;
    [self.contentView addSubview:self.iconImgView];
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.font = FONT_14;
    self.nameLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:self.nameLabel];
}

- (void)layOut {
 
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(self.contentView.mas_height).offset(-10);
        make.left.mas_equalTo(10);
        make.centerY.mas_equalTo(self.contentView);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImgView.mas_right).offset(10);
        make.centerY.mas_equalTo(self.iconImgView);
    }];
}

- (void)configureAddressBookCellWithIconImg: (NSString *)iconImgUrl
                                       name: (NSString *)name {
    if ([iconImgUrl hasPrefix:@"http"]) {
        [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:iconImgUrl] placeholderImage:nil];
    } else {
        self.iconImgView.image = [UIImage imageNamed:iconImgUrl];
    }
    self.nameLabel.text = name;
}

@end
