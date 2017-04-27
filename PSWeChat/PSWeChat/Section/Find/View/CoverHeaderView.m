//
//  CoverHeaderView.m
//  PSWeChat
//
//  Created by 思 彭 on 2017/4/17.
//  Copyright © 2017年 思 彭. All rights reserved.
//

#import "CoverHeaderView.h"

@implementation CoverHeaderView

- (void)awakeFromNib {
    
    [super awakeFromNib];
}

+ (instancetype)coverHeaderViewWithCoverImage: (UIImage *)coverImage name: (NSString *)name avater: (UIImage *)avaterImage {
    
    CoverHeaderView *headerView = [[[NSBundle mainBundle]loadNibNamed:@"CoverHeaderView" owner:nil options:nil] lastObject];
    headerView.translatesAutoresizingMaskIntoConstraints = NO;
    headerView.coverImgView.image = coverImage;
    headerView.nameLabel.text = name;
    [headerView.avaterButton setImage:avaterImage forState:UIControlStateNormal];
    headerView.avaterButton.backgroundColor = [UIColor clearColor];
    headerView.avaterButton.layer.borderWidth = 1.0f;
    headerView.avaterButton.layer.borderColor = [UIColor colorWithWhite:0.95 alpha:1].CGColor;
    return headerView;
}

// 注意:设置xib的布局尺寸在这里设置
- (void)layoutSubviews {

    self.frame = self.bounds;
}

@end
