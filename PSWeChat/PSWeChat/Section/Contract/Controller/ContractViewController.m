//
//  ContractViewController.m
//  PSWeChat
//
//  Created by 思 彭 on 2017/4/14.
//  Copyright © 2017年 思 彭. All rights reserved.
//

#import "ContractViewController.h"
#import "AddressBookCell.h"
#import "FriendModel.h"
#import "SearchResultViewController.h"
#import <MJExtension.h>
#import "ChineseString.h"
#import "pinyin.h"

@interface ContractViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate,SearchResultSelectedDelegate>
{
    NSMutableDictionary *letter_objDic; // 数据源字典
}
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) SearchResultViewController *resultController;
@property (nonatomic, strong) UITableView *contractTableView;;
@property (nonatomic, strong) NSMutableArray *dataMutableArray;
@property (nonatomic, strong) NSMutableArray *updateMutableArray;
@property(nonatomic,strong) NSMutableArray *indexArray; // 索引数组
@property(nonatomic,strong)NSMutableArray *letterResultArr;
@property (nonatomic, strong) NSArray *firstSectionData;

@end

@implementation ContractViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialData];
    [self setupUI];
    [self setupSearchControllerAndSearchResultViewController];
    [self loadData];
}

#pragma mark - initData

- (void)initialData {
   
    self.firstSectionData = @[
                              @[ @"plugins_FriendNotify", @"新的朋友" ],
                              @[ @"add_friend_icon_addgroup", @"群聊" ],
                              @[ @"Contact_icon_ContactTag", @"标签" ],
                              @[ @"add_friend_icon_offical", @"公众号" ]
                              ];
    letter_objDic = [NSMutableDictionary dictionary];
}

#pragma mark - 设置界面

- (void)setupUI {
    
    // 需要设置这句代码,否则会每次点击"搜索",导航栏会将搜索框遮挡部分
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.contractTableView];
    [self.contractTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    // 避免高度显示不全....不懂为什么会显示不全??
    self.contractTableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
}

- (void)setupSearchControllerAndSearchResultViewController {
    
    self.resultController = [[SearchResultViewController alloc]init];
    self.resultController.delegate = self;
    self.searchController = [[UISearchController alloc]initWithSearchResultsController:self.resultController];
    self.searchController.searchResultsUpdater = self.resultController;
    self.searchController.searchBar.tintColor = kThemeColor;
    self.searchController.searchBar.placeholder = @"搜索";
    self.searchController.searchBar.delegate = self;
    self.contractTableView.tableHeaderView = self.searchController.searchBar;
    
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

#pragma mark - 加载数据

- (void)loadData {
    
    NSData *friendsData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"AddressBook" ofType:@"json"]]];
    NSDictionary *JSONDic = [NSJSONSerialization JSONObjectWithData:friendsData options:NSJSONReadingAllowFragments error:nil];
    self.dataMutableArray = [FriendModel mj_objectArrayWithKeyValuesArray:JSONDic[@"friends"][@"row"]];
    [self dealData:self.dataMutableArray];
    self.contractTableView.tableFooterView = [self tableFooterView];
    [self.contractTableView reloadData];
}

#pragma mark - 数据处理

- (void)dealData: (NSMutableArray *)dataArray {
    
    // 数据源model的设置首字母
    if (dataArray && dataArray.count > 0) {
        for (FriendModel *model in dataArray) {
            model.firstLetter = [ChineseString IndexArray:@[model.userName]].firstObject;
        }
    }
    NSMutableArray *tempArray = [NSMutableArray array];
    for (FriendModel *model in dataArray) {
        [tempArray addObject:model.userName];
    }
    if (self.indexArray.count > 0) {
        [self.indexArray removeAllObjects];
    }
    if (self.letterResultArr.count > 0) {
        [self.letterResultArr removeAllObjects];
    }
    self.indexArray = [ChineseString IndexArray:tempArray];
    self.letterResultArr = [ChineseString LetterSortArray:tempArray];
    for (NSInteger i = 0; i < self.indexArray.count; i++) {
        NSMutableArray *arr = [NSMutableArray array];
        [letter_objDic setObject:arr forKey:_indexArray[i]];
    }
    for (int i = 0; i < dataArray.count; i++) {
        FriendModel *model = dataArray[i];
        for (NSString *index in _indexArray) {
            if ([model.firstLetter isEqualToString:index]) {
                NSMutableArray *ziMuArr = letter_objDic[index];
                [ziMuArr addObject:model];
            }
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.indexArray.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return self.firstSectionData.count;
    }
    NSString *sectionTitle = self.indexArray[section - 1]; // 注意section需要-1
    NSArray *sectionArr = letter_objDic[sectionTitle];
    return sectionArr.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AddressBookCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AddressBookCell class]) forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self configureAddressCell:cell indexPath:indexPath];
    return cell;
}

- (void)configureAddressCell: (AddressBookCell *)cell indexPath: (NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        NSArray *arr = self.firstSectionData[indexPath.row];
        [cell configureAddressBookCellWithIconImg:[arr firstObject] name:[arr lastObject]];
    } else {
        NSString *sectionTitle = self.indexArray[indexPath.section - 1];
        NSArray *sectionArr = letter_objDic[sectionTitle];
        FriendModel *model = sectionArr[indexPath.row];
        [cell configureAddressBookCellWithIconImg:model.photo name:model.userName];
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return 50;
    }
    return 60;
}

// TODO:返回区头

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section != 0) {
        
        UITableViewHeaderFooterView *headerView = [[UITableViewHeaderFooterView alloc] init];
        headerView.textLabel.text = self.indexArray[section - 1];
        return headerView;
    }
    return [[UIView alloc]init];
}

// heightOfSection

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return FLT_EPSILON;
    }
    return 24;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    
    return self.indexArray;
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
    [self loadData];
}

// 搜索过滤
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if (searchText && searchText.length > 0) {
        
        for (FriendModel *model in self.dataMutableArray) {
            if ([model.userName containsString:[searchText stringByTrim]]) {
                [self.updateMutableArray addObject:model];
            }
        }
        // 仍然要处理数据排序等...
        [self dealData:self.updateMutableArray];
//        [self.contractTableView reloadData];
        [self.resultController updateAddressBookData:self.updateMutableArray];
    }
}

#pragma mark - SearchResultSelectedDelegate

-(void)selectPersonWithUserId:(NSString *)userId userName:(NSString *)userName photo:(NSString *)photo phoneNO:(NSString *)phoneNO {
    
}

#pragma mark - Private Method

#pragma mark - 懒加载

- (UITableView *)contractTableView {
    
    if (!_contractTableView) {
        _contractTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _contractTableView.delegate = self;
        _contractTableView.dataSource = self;
        // 注册cell
        [_contractTableView registerClass:[AddressBookCell class] forCellReuseIdentifier:NSStringFromClass([AddressBookCell class])];
        // 设置右边索引的字体颜色和背景颜色
        _contractTableView.sectionIndexColor = [UIColor darkGrayColor];
        _contractTableView.sectionIndexBackgroundColor = [UIColor clearColor];
    }
    return _contractTableView;
}

- (NSMutableArray *)dataMutableArray {
    
    if (!_dataMutableArray) {
        _dataMutableArray = [NSMutableArray array];
    }
    return _dataMutableArray;
}

- (NSMutableArray *)updateMutableArray {
    
    if (!_updateMutableArray) {
        _updateMutableArray = [NSMutableArray array];
    }
    return _updateMutableArray;
}

- (UIView *)tableFooterView {
    
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, K_SCREEN_WIDTH, 50)];
    UILabel *label = [[UILabel alloc]initWithFrame:footerView.bounds];
    label.text = [NSString stringWithFormat:@"%lu位联系人 ", (unsigned long)self.dataMutableArray.count];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor lightGrayColor];
    [footerView addSubview:label];
    return footerView;
}

@end
