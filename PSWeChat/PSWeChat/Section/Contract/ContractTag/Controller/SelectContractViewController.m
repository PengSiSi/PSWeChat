//
//  SelectContractViewController.m
//  PSWeChat
//
//  Created by 思 彭 on 2017/5/2.
//  Copyright © 2017年 思 彭. All rights reserved.
//

#import "SelectContractViewController.h"
#import "SelectPersonCell.h"
#import "FriendModel.h"
#import "SearchResultViewController.h"
#import <MJExtension.h>
#import "ChineseString.h"
#import "pinyin.h"
#import "UserSearchBar.h"
#import "WJUserSearchBar.h"

@interface SelectContractViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate,SelectPersonCellDelegate>
{
    NSMutableDictionary *letter_objDic; // 数据源字典
}
@property (nonatomic, strong) UITableView *contractTableView;;
@property (nonatomic, strong) NSMutableArray *dataMutableArray;
@property (nonatomic, strong) NSMutableArray *updateMutableArray;
@property(nonatomic,strong) NSMutableArray *indexArray; // 索引数组
@property(nonatomic,strong) NSMutableArray *letterResultArr;
@property (nonatomic, strong) NSArray *firstSectionData;
@property (nonatomic, strong) UserSearchBar *searchBar;
//@property (nonatomic, strong) WJUserSearchBar *searchBar;

/**
 选择联系人的数据
 */
@property (nonatomic, strong) NSMutableArray *selectPersonDataArray;

@end

@implementation SelectContractViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"选择联系人";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancleAction)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(confirmAction)];
    [self initialData];
    [self loadData];
    [self createUserSearchBar];
    [self setupUI];
}

- (void)initialData {
    
    // 创建字典
    letter_objDic = [[NSMutableDictionary alloc]init];
    self.selectPersonDataArray = [NSMutableArray array];
}

#pragma mark - 设置界面

- (void)createUserSearchBar {
    
    self.searchBar = [[UserSearchBar alloc]initWithFrame:CGRectMake(0, 0, K_SCREEN_WIDTH, 54)];
    self.searchBar.delegate = self;
    [self.view addSubview:self.searchBar];
}

- (void)setupUI {
    
    // 需要设置这句代码,否则会每次点击"搜索",导航栏会将搜索框遮挡部分
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.contractTableView];
    [self.contractTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.searchBar.mas_bottom);
    }];
    // 避免高度显示不全....不懂为什么会显示不全??
//    self.contractTableView.contentInset = UIEdgeInsetsMake(64, 0, 49, 0);
}

#pragma mark - 加载数据

- (void)loadData {
    
    NSData *friendsData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"AddressBook" ofType:@"json"]]];
    NSDictionary *JSONDic = [NSJSONSerialization JSONObjectWithData:friendsData options:NSJSONReadingAllowFragments error:nil];
    self.dataMutableArray = [FriendModel mj_objectArrayWithKeyValuesArray:JSONDic[@"friends"][@"row"]];
    [self dealData:self.dataMutableArray];
    self.contractTableView.tableFooterView = [[UIView alloc]init];
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
        return 1;
    }
    NSString *sectionTitle = self.indexArray[section - 1];
    NSArray *sectionArr = letter_objDic[sectionTitle];
    return sectionArr.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
        cell.textLabel.text = @"从群里导入";
        cell.textLabel.font = FONT_15;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    SelectPersonCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SelectPersonCell class]) forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.selectDelegate = self;
    cell.indexPath = indexPath;
    [self configureAddressCell:cell indexPath:indexPath];
    return cell;
}

- (void)configureAddressCell: (SelectPersonCell *)cell indexPath: (NSIndexPath *)indexPath {

    NSString *sectionTitle = self.indexArray[indexPath.section - 1];
    NSArray *sectionArr = letter_objDic[sectionTitle];
    FriendModel *model = sectionArr[indexPath.row];
    [cell configureCellWithIsSelected:model.isSelected avaterImgUrl:model.photo nameStr:model.userName];
}

#pragma mark - SelectPersonDelegate

- (void)selectButtonDidClick: (NSIndexPath *)indexPath withButton: (UIButton *)button {
    NSString *sectionTitle = self.indexArray[indexPath.section - 1];
    NSArray *sectionArr = letter_objDic[sectionTitle];
    FriendModel *model = sectionArr[indexPath.row];
    model.isSelected = !model.isSelected;
//    if (model.isSelected) {
//        [self.selectPersonDataArray addObject:model];
//    }
    if (model.isSelected) {
        [self.searchBar addUser:model];
    } else {
        [self.searchBar removeUser:model];
    }
    [self.contractTableView reloadData];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - Private Method

- (void)cancleAction {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)confirmAction {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 懒加载

#pragma mark - 懒加载

- (UITableView *)contractTableView {
    
    if (!_contractTableView) {
        _contractTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _contractTableView.delegate = self;
        _contractTableView.dataSource = self;
        _contractTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        // 注册cell
        [_contractTableView registerClass:[SelectPersonCell class] forCellReuseIdentifier:NSStringFromClass([SelectPersonCell class])];
        [_contractTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
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

@end
