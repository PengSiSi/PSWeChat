//
//  MaskView.m
//  PSWeChat
//
//  Created by 思 彭 on 2017/4/18.
//  Copyright © 2017年 思 彭. All rights reserved.
//

#import "MaskView.h"

#define buttonRowNum 2
#define buttonColNum 3

@interface MaskView ()
{
    UIScrollView *scrollView;
    UIVisualEffectView *effectView;
}
@end

@implementation MaskView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 添加模糊遮罩
        [self addBlurEffect];
        [self createSubViews];
    }
    return self;
}

#pragma mark - setupUI

- (void)addBlurEffect {
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    effectView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
    effectView.frame = CGRectMake(0, 0, self.width, self.height);
    [self addSubview:effectView];
}

- (void)createSubViews {
    
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.backgroundColor = [UIColor clearColor];
    [effectView addSubview:scrollView];
    scrollView.contentSize = CGSizeMake(self.width, self.height + 1);
//    [scrollView sendSubviewToBack:self];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, K_SCREEN_WIDTH, 40)];
    label.font = FONT_14;
    label.text = @"搜索指定内容";
    label.textColor = [UIColor lightGrayColor];
    label.textAlignment = NSTextAlignmentCenter;
    [scrollView addSubview:label];
    
    UIView *buttonContainView = [[UIView alloc]initWithFrame:CGRectMake(20, label.bottom + 10, K_SCREEN_WIDTH - 40, 100)];
    [scrollView addSubview:buttonContainView];
    
    // 六个按钮
    CGFloat buttonWidth = buttonContainView.width / buttonColNum;
    CGFloat buttonHeight = buttonContainView.height / buttonRowNum;
    NSArray *buttonTitleArray = @[@[@"朋友圈", @"文章", @"公众号"],@[@"小说", @"音乐", @"表情"]];
    for (NSInteger i = 0; i < buttonRowNum; i++) {
        NSArray *array = buttonTitleArray[i];
        for (NSInteger j = 0; j < buttonColNum; j++) {
            UIButton *button = [UIButton buttonWithType: UIButtonTypeCustom];
            button.frame = CGRectMake(j * buttonWidth, i * buttonHeight, buttonWidth, buttonHeight);
            [button setTitle:array[j] forState:UIControlStateNormal];
            [button setTitleColor:kThemeColor forState:UIControlStateNormal];
            button.titleLabel.textAlignment = NSTextAlignmentCenter;
            button.titleLabel.font = FONT_14;
            [button addTarget:self action:@selector(buttonDidClick:) forControlEvents:UIControlEventTouchUpInside];
            [buttonContainView addSubview:button];
        }
    }
}

#pragma mark - Private Method

- (void)buttonDidClick: (UIButton *)button {
    
    if ([button.titleLabel.text isEqualToString:@"朋友圈"]) {
        
    } else if ([button.titleLabel.text isEqualToString:@"文章"]) {
        
    } else if ([button.titleLabel.text isEqualToString:@"公众号"]) {
        
    } else if ([button.titleLabel.text isEqualToString:@"小说"]) {
        
    } else if ([button.titleLabel.text isEqualToString:@"音乐"]) {
        
    } else if ([button.titleLabel.text isEqualToString:@"表情"]) {
        
    }
}

@end
