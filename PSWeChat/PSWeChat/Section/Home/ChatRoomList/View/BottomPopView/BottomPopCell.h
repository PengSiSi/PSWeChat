//
//  BottomPopCell.h
//  PSWeChat
//
//  Created by 思 彭 on 2017/5/9.
//  Copyright © 2017年 思 彭. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BottomPopCell;

@protocol BottomPopCellDelegate <NSObject>

- (void)didSelectItemCollectionViewCell: (BottomPopCell *)cell indexPath: (NSIndexPath *)indexPath;

@end

@interface BottomPopCell : UICollectionViewCell

@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) NSArray *textArray;

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) id<BottomPopCellDelegate> delegate;
@end
