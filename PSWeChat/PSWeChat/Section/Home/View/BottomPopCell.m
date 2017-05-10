//
//  BottomPopCell.m
//  PSWeChat
//
//  Created by 思 彭 on 2017/5/9.
//  Copyright © 2017年 思 彭. All rights reserved.
//

#import "BottomPopCell.h"
#import "ItemCollectionViewCell.h"

static NSString *const ItemCollectionViewCellID = @"ItemCollectionViewCell";

@interface BottomPopCell ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation BottomPopCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        [self layoutUI];
//        [self testUI];
    }
    return self;
}

#pragma mark - 设置界面

- (void)setupUI {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(K_SCREEN_WIDTH / 4, 180 / 2);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, K_SCREEN_WIDTH, 180) collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self addSubview:self.collectionView];
    [self.collectionView registerClass:[ItemCollectionViewCell class] forCellWithReuseIdentifier:ItemCollectionViewCellID];
}

- (void)layoutUI {
    
}

- (void)testUI {
    
    self.collectionView.backgroundColor = [UIColor greenColor];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.imageArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ItemCollectionViewCellID forIndexPath:indexPath];
    [cell configureCellWithImageName:self.imageArray[indexPath.item] text:self.textArray[indexPath.item]];
    cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
//    return CGSizeMake(K_SCREEN_WIDTH / 4, K_SCREEN_WIDTH / 4 - 10);
    return CGSizeMake(K_SCREEN_WIDTH / 4, 180 / 2);
}

@end
