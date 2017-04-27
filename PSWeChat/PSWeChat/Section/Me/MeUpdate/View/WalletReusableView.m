//
//  WalletReusableView.m
//  PSWeChat
//
//  Created by 思 彭 on 2017/4/21.
//  Copyright © 2017年 思 彭. All rights reserved.
//

#import "WalletReusableView.h"

@implementation WalletReusableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        UILabel *tipLabel = [[UILabel alloc]init];
        tipLabel.font = FONT_14;
        tipLabel.textColor = [UIColor lightGrayColor];
        tipLabel.numberOfLines = 0;
        self.label = tipLabel;
        [self addSubview:tipLabel];
        [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(self).offset(10);
            make.right.mas_equalTo(self).offset(-10);
            make.centerY.mas_equalTo(self);
        }];
    }
    return self;
}

@end
