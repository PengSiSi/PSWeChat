//
//  WSelectPhotoPickerFooterCollectionReusableView.m
//  WNSelectPhoto
//
//  Created by 王楠 on 15/5/21.
//  Copyright (c) 2015年 王楠. All rights reserved.
//

#import "WSelectPhotoPickerFooterCollectionReusableView.h"

@interface WSelectPhotoPickerFooterCollectionReusableView ()
@property (weak, nonatomic) UILabel *footerLabel;

@end

@implementation WSelectPhotoPickerFooterCollectionReusableView
- (UILabel *)footerLabel{
    if (!_footerLabel) {
        UILabel *footerLabel = [[UILabel alloc] init];
        footerLabel.frame = self.bounds;
        footerLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:footerLabel];
        self.footerLabel = footerLabel;
    }
    return _footerLabel;
}

- (void)setCount:(NSInteger)count{
    _count = count;
    if (count > 0) {
        self.footerLabel.text = [NSString stringWithFormat:@"共有 %ld 张图片", (long)count];
    }
}

@end
