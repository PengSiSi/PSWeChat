//
//  WSelectPhotoPickerCollectionView.h
//  WNSelectPhoto
//
//  Created by 王楠 on 15/5/21.
//  Copyright (c) 2015年 王楠. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WSelectPhotoAssets.h"

// 展示状态
typedef NS_ENUM(NSUInteger, WPickerCollectionViewShowOrderStatus){
    WPickerCollectionViewShowOrderStatusTimeDesc = 0, // 升序
    WPickerCollectionViewShowOrderStatusTimeAsc // 降序
};

@class WSelectPhotoPickerCollectionView;
@protocol WPhotoPickerCollectionViewDelegate <NSObject>
// 选择相片就会调用
- (void) pickerCollectionViewDidSelected:(WSelectPhotoPickerCollectionView *) pickerCollectionView deleteAsset:(WSelectPhotoAssets *)deleteAssets;
@end

@interface WSelectPhotoPickerCollectionView : UICollectionView

@property (nonatomic , assign) WPickerCollectionViewShowOrderStatus status;
// 保存所有的数据
@property (nonatomic , strong) NSArray *dataArray;
// 保存选中的图片
@property (nonatomic , strong) NSMutableArray *selectAsstes;
// 最后保存的一次图片
@property (strong,nonatomic) NSMutableArray *lastDataArray;
// delegate
@property (nonatomic , weak) id <WPhotoPickerCollectionViewDelegate> collectionViewDelegate;
// 限制最大数
@property (nonatomic , assign) NSInteger minCount;

// 选中的索引值，为了防止重用
@property (nonatomic , strong) NSMutableArray *selectsIndexPath;
// 记录选中的值
@property (assign,nonatomic) BOOL isRecoderSelectPicker;

@end
