//
//  WSelectPhotoPickerCollectionView.m
//  WNSelectPhoto
//
//  Created by 王楠 on 15/5/21.
//  Copyright (c) 2015年 王楠. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import "WSelectPhotoPickerCollectionView.h"
#import "WSelectPhotoPickerCollectionViewCell.h"
#import "WPhotoPickerImageView.h"
#import "WSelectPhotoPickerFooterCollectionReusableView.h"
#import "WSelectPhotoCommon.h"

@interface WSelectPhotoPickerCollectionView () <UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic , strong) WSelectPhotoPickerFooterCollectionReusableView *footerView;

// 判断是否是第一次加载
@property (nonatomic , assign , getter=isFirstLoadding) BOOL firstLoadding;

@end

@implementation WSelectPhotoPickerCollectionView
#pragma mark -getter
- (NSMutableArray *)selectsIndexPath{
    if (!_selectsIndexPath) {
        _selectsIndexPath = [NSMutableArray array];
    }
    return _selectsIndexPath;
}

#pragma mark -setter
- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    
    // 需要记录选中的值的数据
    if (self.isRecoderSelectPicker){
        NSMutableArray *selectAssets = [NSMutableArray array];
        for (WSelectPhotoAssets *asset in self.selectAsstes) {
            for (WSelectPhotoAssets *asset2 in self.dataArray) {
                if ([asset.asset.defaultRepresentation.url isEqual:asset2.asset.defaultRepresentation.url]) {
                    [selectAssets addObject:asset2];
                    break;
                }
            }
        }
        _selectAsstes = selectAssets;
    }
    
    [self reloadData];
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        
        self.backgroundColor = [UIColor clearColor];
        self.dataSource = self;
        self.delegate = self;
        _selectAsstes = [NSMutableArray array];
    }
    return self;
}

#pragma mark -<UICollectionViewDataSource>
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    WSelectPhotoPickerCollectionViewCell *cell = [WSelectPhotoPickerCollectionViewCell cellWithCollectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    WPhotoPickerImageView *cellImgView = [[WPhotoPickerImageView alloc] initWithFrame:cell.bounds];
    cellImgView.maskViewFlag = YES;
    
    // 需要记录选中的值的数据
    if (self.isRecoderSelectPicker) {
        for (WSelectPhotoAssets *asset in self.selectAsstes) {
            ALAsset *as = (ALAsset *)[self.dataArray[indexPath.item] asset];
            if ([asset.asset.defaultRepresentation.url isEqual:as.defaultRepresentation.url]) {
                [self.selectsIndexPath addObject:@(indexPath.row)];
            }
        }
    }
    
    [cell.contentView addSubview:cellImgView];
    
    cellImgView.maskViewFlag = ([self.selectsIndexPath containsObject:@(indexPath.row)]);
    
    WSelectPhotoAssets *asset = self.dataArray[indexPath.item];
    cellImgView.isVideoType = asset.isVideoType;
    if ([asset isKindOfClass:[WSelectPhotoAssets class]]) {
        cellImgView.image = asset.thumbImage;
    }
    
    return cell;
}

#pragma mark - <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (!self.lastDataArray) {
        self.lastDataArray = [NSMutableArray array];
    }
    
    WSelectPhotoPickerCollectionViewCell *cell = (WSelectPhotoPickerCollectionViewCell *) [collectionView cellForItemAtIndexPath:indexPath];
    
    WSelectPhotoAssets *asset = self.dataArray[indexPath.row];
    WPhotoPickerImageView *pickerImageView = [cell.contentView.subviews lastObject];
    // 如果没有就添加到数组里面，存在就移除
    if (pickerImageView.isMaskViewFlag) {
        [self.selectsIndexPath removeObject:@(indexPath.row)];
        [self.selectAsstes removeObject:asset];
        [self.lastDataArray removeObject:asset];
    }else{
        // 1 判断图片数超过最大数或者小于0
        NSUInteger minCount = (self.minCount < 0) ? KPhotoShowMaxCount :  self.minCount;
        
        if (self.selectAsstes.count >= minCount) {
            NSString *format = [NSString stringWithFormat:@"最多只能选择%zd张图片",minCount];
            if (minCount == 0) {
                format = [NSString stringWithFormat:@"你最多只能选择9张照片"];
            }
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:format message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"我知道了", nil];
            [alertView show];
            return ;
        }
        
        [self.selectsIndexPath addObject:@(indexPath.row)];
        [self.selectAsstes addObject:asset];
        [self.lastDataArray addObject:asset];
    }
    // 告诉代理现在被点击了!
    if ([self.collectionViewDelegate respondsToSelector:@selector(pickerCollectionViewDidSelected: deleteAsset:)]) {
        if (pickerImageView.isMaskViewFlag) {
            // 删除的情况下
            [self.collectionViewDelegate pickerCollectionViewDidSelected:self deleteAsset:asset];
        }else{
            [self.collectionViewDelegate pickerCollectionViewDidSelected:self deleteAsset:nil];
        }
    }
    
    pickerImageView.maskViewFlag = ([pickerImageView isKindOfClass:[WPhotoPickerImageView class]]) && !pickerImageView.isMaskViewFlag;
    
    
}

#pragma mark 底部View
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    WSelectPhotoPickerFooterCollectionReusableView *reusableView = nil;
    if (kind == UICollectionElementKindSectionFooter) {
        WSelectPhotoPickerFooterCollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
        footerView.count = self.dataArray.count;
        reusableView = footerView;
        self.footerView = footerView;
    }else{
        
    }
    return reusableView;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    // 时间置顶的话
    if (self.status == WPickerCollectionViewShowOrderStatusTimeDesc) {
        if (!self.firstLoadding && self.contentSize.height > [[UIScreen mainScreen] bounds].size.height) {
            // 滚动到最底部（最新的）
            [self scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.dataArray.count - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
            // 展示图片数
            self.contentOffset = CGPointMake(self.contentOffset.x, self.contentOffset.y + 100);
            self.firstLoadding = YES;
        }
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
