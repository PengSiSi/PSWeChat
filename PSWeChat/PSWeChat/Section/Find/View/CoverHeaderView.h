//
//  CoverHeaderView.h
//  PSWeChat
//
//  Created by 思 彭 on 2017/4/17.
//  Copyright © 2017年 思 彭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CoverHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *coverImgView;
@property (weak, nonatomic) IBOutlet UIButton *avaterButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

+ (instancetype)coverHeaderViewWithCoverImage: (UIImage *)avaterImage name: (NSString *)name avater: (UIImage *)avaterIamge;

@end
