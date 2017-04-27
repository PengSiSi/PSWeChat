//
//  SelectPhotoCollectionViewCell.m
//  Donghuamen
//
//  Created by AlicePan on 16/11/24.
//  Copyright © 2016年 Combanc. All rights reserved.
//

#import "SelectPhotoCollectionViewCell.h"

@implementation SelectPhotoCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self setUI];
    }
    return self;
}

- (void)setUI {
    self.imageV = [[UIImageView alloc]init];
    self.imageV.clipsToBounds = YES;
    self.imageV.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:self.imageV];
    
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    self.deleteImgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.deleteImgBtn setImage:[UIImage imageNamed:@"contacts_groupinfo_rename_delete"] forState:UIControlStateNormal];
    [self.deleteImgBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.deleteImgBtn.hidden = YES;
    [self.contentView addSubview:self.deleteImgBtn];
    
    [self.deleteImgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.width.height.mas_equalTo(18);
    }];
}

- (void)BtnClick:(UIButton *)btn{
    if (_deleteImageBtnClick) {
        _deleteImageBtnClick(btn);
    }
}

@end
