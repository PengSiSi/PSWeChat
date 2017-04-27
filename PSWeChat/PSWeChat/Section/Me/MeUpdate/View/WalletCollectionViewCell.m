//
//  WalletCollectionViewCell.m
//  PSWeChat
//
//  Created by 思 彭 on 2017/4/21.
//  Copyright © 2017年 思 彭. All rights reserved.
//

#import "WalletCollectionViewCell.h"

@interface WalletCollectionViewCell ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation WalletCollectionViewCell

- (UIImageView *)imageView{
    if (!_imageView) {
//        _imageView = [[UIImageView alloc] initWithFrame:self.viewForFirstBaselineLayout.bounds];
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake((self.contentView.width - getWidth(40)) / 2, 20, getWidth(40), getWidth(40))];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_imageView];
    }return _imageView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.bounds) - 50, CGRectGetWidth(self.contentView.frame), 30)];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = FONT_15;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_titleLabel];
    }return _titleLabel;
}

- (void)configureWalletCollectionViewCellWithTitle: (NSString *)titleStr
                                         imageName: (NSString *)imageStr {
    self.imageView.image = [UIImage imageNamed:imageStr];
    self.titleLabel.text = titleStr;
}

@end
