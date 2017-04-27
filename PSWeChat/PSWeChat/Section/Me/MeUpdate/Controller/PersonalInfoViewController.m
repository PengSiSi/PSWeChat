//
//  PersonalInfoViewController.m
//  PSWeChat
//
//  Created by 思 彭 on 2017/4/18.
//  Copyright © 2017年 思 彭. All rights reserved.
//

#import "PersonalInfoViewController.h"
#import "LeftLabelAndRightImgViewCell.h"
#import "LabelTableViewCell.h"
#import "PersonAvaterViewController.h"
#import "PersonAddressViewController.h"
#import "AreaListViewController.h"

@interface PersonalInfoViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSArray *contentArray;
@property (nonatomic, copy) NSString *selectAreaStr;

@end

@implementation PersonalInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialData];
    [self setUI];
    // 接收选择地区通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveNotification:) name:SelectAreaSuccessNotification object:nil];
}

- (void)receiveNotification: (NSNotification *)notification {
    
    self.selectAreaStr = notification.userInfo[@"selectArea"];
    [self initialData];
    [self.tableView reloadData];
}

#pragma mark - 设置界面

- (void)initialData {
    
    self.dataArray = @[@[@"头像", @"名字", @"微信号", @"我的二维码", @"我的地址"], @[@"性别", @"地区", @"个性签名"]];
    self.contentArray = @[@[@"jingdizhiwa", @"思思", @"玉思盈蝶", @"ScanQRCode", @""],@[@"女", self.selectAreaStr ? : @"北京 海淀", @"没什么大不了"]];
}

- (void)setUI {
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, K_SCREEN_WIDTH, K_SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    // 注册cell
    [self.tableView registerClass:[LabelTableViewCell class] forCellReuseIdentifier:NSStringFromClass([LabelTableViewCell class])];
    [self.tableView registerClass:[LeftLabelAndRightImgViewCell class] forCellReuseIdentifier:NSStringFromClass([LeftLabelAndRightImgViewCell class])];
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview: self.tableView];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return ((NSArray *)(self.dataArray[section])).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0 || indexPath.row == 3) {
            LeftLabelAndRightImgViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LeftLabelAndRightImgViewCell class]) forIndexPath:indexPath];
            [self configureLeftLabelAndRightImgViewTabelViewCell:cell indexPath:indexPath];
            return cell;
        } else {
            LabelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LabelTableViewCell class]) forIndexPath:indexPath];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [self configureLabelTabelViewCell:cell indexPath:indexPath];
            return cell;
        }
    } else {
        LabelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LabelTableViewCell class]) forIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self configureLabelTabelViewCell:cell indexPath:indexPath];
        return cell;
    }
}

- (void)configureLeftLabelAndRightImgViewTabelViewCell: (LeftLabelAndRightImgViewCell *)cell indexPath: (NSIndexPath *)indexPath {
    
    NSArray *array = self.dataArray[indexPath.section];
    NSArray *contentArray = self.contentArray[indexPath.section];
    [cell configureLabelText:array[indexPath.row] imageName:contentArray[indexPath.row]];
}

- (void)configureLabelTabelViewCell: (LabelTableViewCell *)cell indexPath: (NSIndexPath *)indexPath {
    
    
    NSArray *array = self.dataArray[indexPath.section];
    NSArray *contentArray = self.contentArray[indexPath.section];
    [cell configureLeftLabelText:array[indexPath.row] rightLabeltext:contentArray[indexPath.row]];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 60;
    } else {
        return 44;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                // 个人头像
                NSArray *contentArray = self.contentArray[indexPath.section];
                PersonAvaterViewController *personAvaterVc = [PersonAvaterViewController PersonAvaterViewControllerage:[UIImage imageNamed:contentArray[indexPath.row]]];
                personAvaterVc.navigationItem.title = @"个人头像";
                [self.navigationController pushViewController:personAvaterVc animated:YES];
                break;
            }
            case 1:
            {
                // 个人头像
                PersonAvaterViewController *personAvaterVc = [[PersonAvaterViewController alloc]init];
                [self.navigationController pushViewController:personAvaterVc animated:YES];
                break;
            }
            case 2:
            {
                // 个人头像
                PersonAvaterViewController *personAvaterVc = [[PersonAvaterViewController alloc]init];
                [self.navigationController pushViewController:personAvaterVc animated:YES];
                break;
            }
            case 3:
            {
                // 个人头像
                PersonAvaterViewController *personAvaterVc = [[PersonAvaterViewController alloc]init];
                [self.navigationController pushViewController:personAvaterVc animated:YES];
                break;
            }
            case 4:
            {
                // 个人头像
                PersonAddressViewController *addressVc = [[PersonAddressViewController alloc]init];
                self.navigationItem.title = @"我的地址";
                [self.navigationController pushViewController:addressVc animated:YES];
                break;
            }
            default:
                break;
        }
    } else {
        
        switch (indexPath.row) {
            case 0:
                // 性别
                break;
            case 1:
            {
                // 地区
                AreaListViewController *areaListVc = [[AreaListViewController alloc]init];
                areaListVc.navigationItem.title = @"地区";
                [self.navigationController pushViewController:areaListVc animated:YES];
                break;
            }
            default:
                break;
        }
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
