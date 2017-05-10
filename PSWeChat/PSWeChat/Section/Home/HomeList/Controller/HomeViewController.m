//
//  HomeViewController.m
//  PSWeChat
//
//  Created by 思 彭 on 2017/4/14.
//  Copyright © 2017年 思 彭. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeTableViewCell.h"
#import "UIImage+RandomImage.h"
#import "HomeSearchViewController.h"
#import "MaskView.h"
#import "YCXMenu.h"
#import "ChatRoomViewController.h"
#import "SubLBXScanViewController.h"

@interface HomeViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) HomeSearchViewController *resultController;
@property (nonatomic, strong) MaskView *maskView;
@property (nonatomic , strong) NSMutableArray *menuItems;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNotification];
    [self initializeData];
    [self buildTableView];
    [self setupBarButtonRightItem];
    [self setupSearchControllerAndSearchResultViewController];
}

- (void)addNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuWillAppear) name:YCXMenuWillAppearNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuDidAppear) name:YCXMenuDidAppearNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuWillDisappear) name:YCXMenuWillDisappearNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuDidDisappear) name:YCXMenuDidDisappearNotification object:nil];
}

- (void)initializeData
{
    self.dataArray = @[
                     @[ @"吴正祥", @"*Github: https://github.com/Seanwong933" ],
                     @[ @"陈维", @"*博客地址: http://siegrain.wang" ],
                     @[ @"赖杰", @"*本应用集成了图灵机器人的自动聊天功能" ],
                     @[ @"范熙丹", @"*麻麻再也不怕进来之后没有事干了..." ],
                     @[
                         @"丁亮",
                         @"*PS: 聊天内容使用CoreData进行缓存"
                         ],
                     @[ @"赵雨彤",
                        @"您已添加了Darui Li，现在可以开始聊天了。" ],
                     @[ @"落落",
                        @"刚翻到了之前给肉团儿拍的小时候皂片！！！" ],
                     @[ @"Leo琦仔", @"Leo琦仔 领取了您的红包" ],
                     @[ @"廖宇超", @"[动画表情]" ],
                     @[ @"Darui Li",
                        @"关于刘亦菲美貌的8歌秘密，你知道几个？" ],
                     @[ @"刘洋", @"逼乎日报" ]
                     ];
}

- (void)buildTableView {
    
    // tableviewstyle为groupped的话，会有莫名其妙的contentInsets出现
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView = [[UITableView alloc]
                      initWithFrame:CGRectMake(0, 0, K_SCREEN_WIDTH, K_SCREEN_HEIGHT - 64)
                      style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 64, 0);
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[HomeTableViewCell class] forCellReuseIdentifier:NSStringFromClass([HomeTableViewCell class])];
}

- (void)setupBarButtonRightItem {
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addBarButtonItemDidClick:)];
}

- (void)setupSearchControllerAndSearchResultViewController {
    
    self.resultController = [[HomeSearchViewController alloc]init];
    self.searchController = [[UISearchController alloc]initWithSearchResultsController:self.resultController];
    self.searchController.searchResultsUpdater = self.resultController;
    self.searchController.searchBar.tintColor = kThemeColor;
    // 设置关闭输入预测
    [self.searchController.searchBar setAutocorrectionType:UITextAutocorrectionTypeNo];
    [self.searchController.searchBar setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    
    // 点击背景是否dismiss
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchBar.placeholder = @"搜索";
    self.searchController.searchBar.delegate = self;
    self.searchController.delegate = self;
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    //解决iOS 8.4中searchBar看不到的bug
    UISearchBar *bar = self.searchController.searchBar;
    bar.barStyle = UIBarStyleDefault;
    bar.translucent = YES;
    CGRect rect = bar.frame;
    rect.size.height = 44;
    bar.frame = rect;
    
    //设置searchBar的边框颜色，四周的颜色
    self.searchController.searchBar.barTintColor = [UIColor groupTableViewBackgroundColor];
    UIImageView *imgView = [[[self.searchController.searchBar.subviews objectAtIndex:0]subviews]firstObject];
    imgView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    imgView.layer.borderWidth = 1;
    
    // 修改UISearchBar的右边图标
    self.searchController.searchBar.showsBookmarkButton = YES;
    [self.searchController.searchBar setImage:[UIImage imageNamed:@"VoiceSearchStartBtn"] forSearchBarIcon:UISearchBarIconBookmark state:UIControlStateNormal];
    // 修改searchBar取消按钮的文字为中文
    // appearanceWhenContainedInInstancesOfClasses: instead
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil]setTitle:@"取消"];
    self.definesPresentationContext = YES;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HomeTableViewCell class]) forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.preservesSuperviewLayoutMargins = false;
    cell.separatorInset = UIEdgeInsetsMake(5, 0, 0, 0);
    cell.layoutMargins = UIEdgeInsetsZero;
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return FLT_EPSILON;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return FLT_EPSILON;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 60;
}

- (void)tableView:(UITableView*)tableView willDisplayCell:(HomeTableViewCell*)cell forRowAtIndexPath:(NSIndexPath*)indexPath {
    
    cell.avatarImgView.image = [UIImage randomImageInPath:@"Images/cell_icons"];
    cell.nameLabel.text = self.dataArray[indexPath.row][0];
    cell.descriptionLabel.text = self.dataArray[indexPath.row][1];
    cell.timeLabel.text = @"12:30";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ChatRoomViewController *chatRoomVc = [[ChatRoomViewController alloc]init];
    [self.navigationController pushViewController:chatRoomVc animated:YES];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    
    self.searchController.searchBar.showsCancelButton = YES;
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    // "搜索"按钮点击,收起键盘
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    [searchBar resignFirstResponder];
}

// 搜索过滤
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
}

#pragma mark - UISearchControllerDelegate

- (void)willPresentSearchController:(UISearchController*)searchController
{
    [self.view addSubview:self.maskView];
}

- (void)willDismissSearchController:(UISearchController*)searchController
{
    [self.maskView removeFromSuperview];
}

#pragma mark - Private Method

- (void)addBarButtonItemDidClick: (UIBarButtonItem *)item {
    
    [YCXMenu setTintColor:[UIColor colorWithRed:54 / 255.0
                                          green:53 / 255.0
                                           blue:58 / 255.0
                                          alpha:1]];
    [YCXMenu setSelectedColor:[UIColor colorWithRed:54 / 255.0
                                              green:53 / 255.0
                                               blue:58 / 255.0
                                              alpha:1]];
    [YCXMenu setBackgrounColorEffect:YCXMenuBackgrounColorEffectSolid];
    if ([YCXMenu isShow]){
        [YCXMenu dismissMenu];
    } else {
        [YCXMenu showMenuInView:self.view fromRect:CGRectMake(self.view.frame.size.width - 60, 0, 60, 0) menuItems:self.items selected:^(NSInteger index, YCXMenuItem *item) {
            NSLog(@"%@",item);
            switch (index) {
                case 0:
                {
                    NSLog(@"发起群聊");
                    break;
                }
                case 1:
                {
                    NSLog(@"添加朋友");
                    break;
                }case 2:
                {
                    NSLog(@"扫一扫");
                    SubLBXScanViewController *scanVc = [[SubLBXScanViewController alloc]init];
                    [self.navigationController pushViewController:scanVc animated:YES];
                    break;
                }case 3:
                {
                    NSLog(@"收付款");
                    break;
                }
                default:
                    break;
            }
        }];
    }
}

#pragma mark - Notification Method

- (void)menuWillAppear {
    NSLog(@"menu will appear");
}

- (void)menuDidAppear {
    NSLog(@"menu did appear");
}

- (void)menuWillDisappear {
    NSLog(@"menu will disappear");
}

- (void)menuDidDisappear {
    NSLog(@"menu did disappear");
}

#pragma mark - 懒加载

- (MaskView *)maskView {
    
    if (!_maskView) {
        _maskView = [[MaskView alloc]initWithFrame:CGRectMake(0, 64, K_SCREEN_WIDTH, K_SCREEN_HEIGHT)];
    }
    return _maskView;
}

#pragma mark - setter/getter
- (NSMutableArray *)items {
    if (!_menuItems) {
        //set item
        _menuItems = [@[
                    [YCXMenuItem menuItem:@"发起群聊"
                                    image:[UIImage imageNamed:@"f_application_hs_share_praise_icon_pressed"]
                                      tag:100
                                 userInfo:@{@"title":@"Menu"}],
                    [YCXMenuItem menuItem:@"添加朋友"
                                    image:[UIImage imageNamed:@"f_application_hs_share_praise_icon_pressed"]
                                      tag:101
                                 userInfo:@{@"title":@"Menu"}],
                    [YCXMenuItem menuItem:@"扫一扫"
                                    image:[UIImage imageNamed:@"f_application_hs_share_praise_icon_pressed"]
                                      tag:102
                                 userInfo:@{@"title":@"Menu"}],
                    [YCXMenuItem menuItem:@"收付款"
                                    image:[UIImage imageNamed:@"f_application_hs_share_praise_icon_pressed"]
                                      tag:102
                                 userInfo:@{@"title":@"Menu"}]
                    ] mutableCopy];
    }
    return _menuItems;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
