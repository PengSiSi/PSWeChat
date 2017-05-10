//
//  BottomPopView.h
//  PSWeChat
//
//  Created by 思 彭 on 2017/5/9.
//  Copyright © 2017年 思 彭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BottomPopView : UIView <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pageControlBottom;

+ (BottomPopView *)bottomPopView;

@end
