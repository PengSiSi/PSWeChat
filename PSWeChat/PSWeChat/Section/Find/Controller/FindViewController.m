//
//  FindViewController.m
//  PSWeChat
//
//  Created by 思 彭 on 2017/4/14.
//  Copyright © 2017年 思 彭. All rights reserved.
//

#import "FindViewController.h"
#import "FriendCircleViewController.h"

@interface FindViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView* tableView;
//名字数组
@property (nonatomic, copy) NSArray* dataArr;
//图片数组
@property (nonatomic, copy) NSArray* imgArr;
@property (nonatomic, strong) FriendCircleViewController *friendCircleVc;

@end

@implementation FindViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeData];
    [self setupUI];
}

#pragma mark - initData

- (void)initializeData {
    
    _dataArr = @[
                 @[ @"朋友圈" ],
                 @[ @"扫一扫", @"摇一摇" ],
                 @[ @"附近的人" ],
                 @[ @"购物", @"游戏" ]
                 ];
    
    _imgArr = @[
                @[ @"ff_IconShowAlbum" ],
                @[ @"ff_IconQRCode", @"ff_IconBottle" ],
                @[ @"ff_IconLocationService" ],
                @[ @"CreditCard_ShoppingBag", @"MoreGame" ]
                ];
}

#pragma mark - 设置界面

- (void)setupUI {
    
    _tableView = ({
        UITableView* tableView = [[UITableView alloc]
                                  initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,
                                                           self.view.frame.size.height - 44)
                                  style:UITableViewStyleGrouped];
        tableView.delegate = self;
        tableView.dataSource = self;
        //调整两个cell之间的分割线的长度
        tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        tableView;
    });
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
    
    return _dataArr.count;
}

- (NSInteger)tableView:(UITableView*)tableView
 numberOfRowsInSection:(NSInteger)section {
    
    NSArray* rowArr = _dataArr[section];
    return rowArr.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView
        cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    
    static NSString* identifier = @"foundCellIdentifier";
    UITableViewCell* cell =
    [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:identifier];
    }
    //右侧小箭头
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView*)tableView willDisplayCell:(UITableViewCell*)cell forRowAtIndexPath:(NSIndexPath*)indexPath {
    
    cell.imageView.image =
    [UIImage imageNamed:_imgArr[indexPath.section][indexPath.row]];
    cell.textLabel.text = _dataArr[indexPath.section][indexPath.row];
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
    
    return 44;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section {
    
    return section == 0 ? 15.0f : 5.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController pushViewController:self.friendCircleVc animated:YES];
}

#pragma mark - Private Method

#pragma mark - 懒加载

- (FriendCircleViewController *)friendCircleVc {
    
    if (!_friendCircleVc) {
        _friendCircleVc = [[FriendCircleViewController alloc]init];
    }
    return _friendCircleVc;
}

@end
