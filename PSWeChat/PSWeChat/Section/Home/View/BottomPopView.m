//
//  BottomPopView.m
//  PSWeChat
//
//  Created by 思 彭 on 2017/5/9.
//  Copyright © 2017年 思 彭. All rights reserved.
//

#import "BottomPopView.h"
#import "BottomPopCell.h"

@interface BottomPopView ()

@property (nonatomic, strong) NSArray *imgsArray;
@property (nonatomic, strong) NSArray *textsArray;

@end

@implementation BottomPopView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.pageControl.currentPage = 0;
    self.collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
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

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 1;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BottomPopCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([BottomPopCell class]) forIndexPath:indexPath];
    cell.imageArray = self.imgsArray[indexPath.section];
    cell.textArray = self.textsArray[indexPath.section];
    return cell;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    CGFloat offsetX = scrollView.contentOffset.x;
    NSLog(@"%f",offsetX);
    
    // 这里处理的逻辑好像有点问题,待完善...
    if (offsetX > 0) {
        // 这里注意要+1,翻一页是屏幕宽
        self.pageControl.currentPage = offsetX / K_SCREEN_WIDTH + 1;
    } else {
        self.pageControl.currentPage = offsetX / K_SCREEN_WIDTH;
    }
}

#pragma mark - Setter && Getter

- (NSArray *)imgsArray {
    
    return @[@[@"actionbar_picture_icon", @"actionbar_camera_icon", @"actionbar_picture_icon", @"actionbar_location_icon",@"actionbar_picture_icon", @"actionbar_picture_icon", @"actionbar_picture_icon", @"actionbar_picture_icon"], @[@"actionbar_picture_icon", @"actionbar_picture_icon"]];
}

- (NSArray *)textsArray {
    
    return @[@[@"照片", @"拍摄", @"视频聊天", @"位置", @"红包", @"转账", @"个人名片", @"语音输入"], @[@"收藏", @"卡券"]];
}
@end
