//
//  WSelectPhotoPickerCollectionViewCell.m
//  WNSelectPhoto
//
//  Created by 王楠 on 15/5/21.
//  Copyright (c) 2015年 王楠. All rights reserved.
//

#import "WSelectPhotoPickerCollectionViewCell.h"

static NSString *const _cellIdentifier = @"cell";

@implementation WSelectPhotoPickerCollectionViewCell

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    WSelectPhotoPickerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:_cellIdentifier forIndexPath:indexPath];
    
    if ([[cell.contentView.subviews lastObject] isKindOfClass:[UIImageView class]]) {
        [[cell.contentView.subviews lastObject] removeFromSuperview];
    }
    
    return cell;
}
@end
