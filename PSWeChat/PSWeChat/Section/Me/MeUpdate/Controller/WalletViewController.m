//
//  WalletViewController.m
//  PSWeChat
//
//  Created by 思 彭 on 2017/4/21.
//  Copyright © 2017年 思 彭. All rights reserved.
//

#import "WalletViewController.h"
#import "WalletHeaderView.h"
#import "WalletCollectionViewCell.h"
#import "WalletReusableView.h"

static NSString *const collectionViewCellID = @"collectionViewCellID";
static NSString *const collectionHeaderViewID = @"collectionHeaderViewID";

@interface WalletViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *sectionTitlesArray;
@property (nonatomic, strong) NSArray *cellTitlesArray;
@property (nonatomic, strong) NSArray *cellIconsArray;

@end

@implementation WalletViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initialData];
    [self setCollectionView];
    [self setHeaderView];
}

#pragma mark - initialData

- (void)initialData {
    
    self.sectionTitlesArray = @[@"腾讯服务", @"第三方服务"];
    self.cellIconsArray = @[@[@"ProfileLockOn",@"ProfileLockOn",@"ProfileLockOn",@"ProfileLockOn",@"ProfileLockOn",@"ProfileLockOn", @"ProfileLockOn"], @[@"ProfileLockOn",@"ProfileLockOn",@"ProfileLockOn"]];
    self.cellTitlesArray = @[@[@"面对面红包", @"手机充值", @"理财通", @"微粒贷借钱", @"Q币充值", @"生活缴费", @"城市服务"], @[@"摩拜单车", @"滴滴出行", @"火车票机票"]];
}

#pragma mark - setUI

- (void)setCollectionView {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake((K_SCREEN_WIDTH) / 3, (K_SCREEN_WIDTH) / 3);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    
    // 话说在 iPhone 6 或 iPhone 6s 上会有一条缝出现,我从来没出现过,有知道可以告诉我一下... http://www.jianshu.com/p/0cb9ab47842f
    self.collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    // 最重要的一句代码!!!
    self.collectionView.contentInset = UIEdgeInsetsMake(getHeight(160), 0, 0, 0);
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.collectionView];
    
    // 注册cell
    [self.collectionView registerClass:[WalletCollectionViewCell class] forCellWithReuseIdentifier:collectionViewCellID];
    [self.collectionView registerClass:[WalletReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:collectionHeaderViewID];
}

- (void)setHeaderView {
    
    // 注意这里设置headerView的头视图的y坐标一定是从"负值"开始,因为headerView是添加在collectionView上的.
    WalletHeaderView *headerView = [[WalletHeaderView alloc]initWithFrame:CGRectMake(0, -getHeight(160), self.view.frame.size.width, getHeight(160))];
    headerView.backgroundColor = ColorRGB(104, 110, 120);
    [self.collectionView addSubview:headerView];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return self.sectionTitlesArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return ((NSArray *)(self.cellIconsArray[section])).count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WalletCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewCellID forIndexPath:indexPath];
    // 设置cell的分割线显示
    cell.layer.borderColor=[UIColor lightGrayColor].CGColor;
    cell.layer.borderWidth = 0.3;
    cell.backgroundColor = [UIColor whiteColor];
    [self configureCollectionView:cell indexPath:indexPath];
    return cell;
}

- (void)configureCollectionView: (WalletCollectionViewCell *)cell indexPath: (NSIndexPath *)indexPath {
    
    NSArray *iconArray = self.cellIconsArray[indexPath.section];
    NSArray *titleArray = self.cellTitlesArray[indexPath.section];
    [cell configureWalletCollectionViewCellWithTitle:titleArray[indexPath.row] imageName:iconArray[indexPath.row]];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark - UICollectionViewDelegate

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {

    /**
     ** Assertion failure in -[UICollectionView _createPreparedSupplementaryViewForElementOfKind:atIndexPath:withLayoutAttributes:applyAttributes:]
     出现此错误的原因就是下面的方法里面
     
     - (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
     不可 alloc 你想要的view 需要通过collectionView的dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kProductSectionFooterIdentifier forIndexPath:indexPath方法复用
    UICollectionReusableView *sectionHeaderView = [[UICollectionReusableView alloc]initWithFrame:CGRectMake(0, 0, K_SCREEN_WIDTH, 44)];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, K_SCREEN_WIDTH, 44)];
    [sectionHeaderView addSubview:label];
    return sectionHeaderView;
     */
    WalletReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:collectionHeaderViewID forIndexPath:indexPath];
    view.label.text = self.sectionTitlesArray[indexPath.section];
    return view;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    return CGSizeMake(self.view.frame.size.width, 30);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(K_SCREEN_WIDTH / 3, K_SCREEN_WIDTH / 3);
}

@end
