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

- (void)setupUI {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(K_SCREEN_WIDTH / 4, (K_SCREEN_WIDTH / 4) - 10);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, K_SCREEN_WIDTH, self.contentView.height) collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.contentView addSubview:self.collectionView];
    [self.collectionView registerClass:[ItemCollectionViewCell class] forCellWithReuseIdentifier:ItemCollectionViewCellID];
}

- (void)layoutUI {
    
}

- (void)testUI {
    
    self.collectionView.backgroundColor = [UIColor greenColor];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 8;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ItemCollectionViewCellID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(K_SCREEN_WIDTH / 4, K_SCREEN_WIDTH / 4 - 10);
}

@end
