//
//  WalletHeaderView.m
//  PSWeChat
//
//  Created by 思 彭 on 2017/4/21.
//  Copyright © 2017年 思 彭. All rights reserved.
//

#import "WalletHeaderView.h"

@interface WalletHeaderView ()

@property (nonatomic, strong) NSArray *imagesArray;
@property (nonatomic, strong) NSArray *titlesArray;
@property (nonatomic, strong) NSArray *contentsArray;

@end

@implementation WalletHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    
    self.imagesArray = @[@"barbuttonicon_set", @"barbuttonicon_set", @"barbuttonicon_set"];
    self.titlesArray = @[@"收付款", @"零钱", @"银行卡"];
    self.contentsArray = @[@"", @"100.5", @""];
    
    CGFloat width = K_SCREEN_WIDTH / self.imagesArray.count;
    for (NSInteger i = 0; i < self.imagesArray.count; i++) {
        
        UIView *itemView = [self createItemViewWithImageName:self.imagesArray[i] titleStr:self.titlesArray[i] contentStr:self.contentsArray[i] width:width];
        itemView.frame = CGRectMake(i * width, 10, width, 200);
        [self addSubview:itemView];
    }
}


/**
 创建带图片,标题,详情的view

 @param imageName 图片名
 @param titleStr 标题名
 @param contentStr 详情名
 @return 创建好的view
 */
- (UIView *)createItemViewWithImageName: (NSString *)imageName titleStr: (NSString *)titleStr contentStr: (NSString *)contentStr width: (CGFloat)width {
    
    UIView *containerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, 100)];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((containerView.width - getWidth(40)) / 2, 20, getWidth(40), getWidth(40))];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = [UIImage imageNamed:imageName];
    [containerView addSubview:imageView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, imageView.bottom + 10, width, 20)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = FONT_15;
    titleLabel.text = titleStr;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [containerView addSubview:titleLabel];
    
    UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, titleLabel.bottom + 10, width, 20)];
    contentLabel.textColor = [UIColor whiteColor];
    contentLabel.font = FONT_15;
    contentLabel.text = contentStr;
    contentLabel.textAlignment = NSTextAlignmentCenter;
    [containerView addSubview:contentLabel];
    return containerView;
}

@end
