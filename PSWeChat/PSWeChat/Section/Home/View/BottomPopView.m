//
//  BottomPopView.m
//  PSWeChat
//
//  Created by 思 彭 on 2017/5/9.
//  Copyright © 2017年 思 彭. All rights reserved.
//

#import "BottomPopView.h"
#import "BottomPopCell.h"

@implementation BottomPopView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    // 注册cell（在awakeFromNib中注册）
    [self.collectionView registerClass:[BottomPopCell class] forCellWithReuseIdentifier:NSStringFromClass([BottomPopCell class])];
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    //设置布局（在layoutSubviews中设置，该位置可以拿到正确的尺寸）
    UICollectionViewFlowLayout *layout = self.collectionView.collectionViewLayout;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.itemSize = self.collectionView.bounds.size;
}

+ (BottomPopView *)bottomPopView {
    
    return [[NSBundle mainBundle]loadNibNamed:@"BottomPopView" owner:nil options:nil].lastObject;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 2;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BottomPopCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([BottomPopCell class]) forIndexPath:indexPath];
    return cell;
}

@end
