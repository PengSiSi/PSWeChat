//
//  BottomPopView.h
//  PSWeChat
//
//  Created by 思 彭 on 2017/5/9.
//  Copyright © 2017年 思 彭. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 点击底部View的Cell的block回调
 @param indexPath indexPath
 */
typedef void(^DidSelectCollectionViewCellBlock)(NSIndexPath *indexPath);

@interface BottomPopView : UIView <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pageControlBottom;
@property (nonatomic, copy) DidSelectCollectionViewCellBlock block ;

+ (BottomPopView *)bottomPopView;

@end
