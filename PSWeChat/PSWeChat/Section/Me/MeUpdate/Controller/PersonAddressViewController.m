//
//  PersonAddressViewController.m
//  PSWeChat
//
//  Created by 思 彭 on 2017/4/19.
//  Copyright © 2017年 思 彭. All rights reserved.
//

#import "PersonAddressViewController.h"
#import "AddressTableViewCell.h"
#import "UpdateAddressViewController.h"
#import "AddAddressManager.h"
#import <UITableView+FDTemplateLayoutCell.h>
#import "WLAlertViewController.h"

@interface PersonAddressViewController ()<UITableViewDelegate, UITableViewDataSource, WLAlertViewControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSIndexPath *deleteIndexPath;

@end

@implementation PersonAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self readData];
    [self setUI];
}

#pragma mark - 读取数据库

- (void)readData {
    
    self.dataArray = [[[AddAddressManager shareInstance]readAllAddressList] mutableCopy];
    [self.tableView reloadData];
}

#pragma mark - 设置界面

- (void)setUI {
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, K_SCREEN_WIDTH, K_SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    // 注册cell
    [self.tableView registerClass:[AddressTableViewCell class] forCellReuseIdentifier:@"AddressBookCell"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return section == 0 ? self.dataArray.count : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        /*
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            cell.imageView.image = [UIImage imageNamed:@"form_add"];
            cell.textLabel.text = @"新增地址";
            cell.textLabel.font = FONT_14;
            cell.accessoryType = UITableViewCellAccessoryDetailButton;
        }
        return cell;
         */
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.imageView.image = [UIImage imageNamed:@"form_add"];
        cell.textLabel.text = @"新增地址";
        cell.textLabel.font = FONT_14;
        cell.accessoryType = UITableViewCellAccessoryDetailButton;
        return cell;
    } else {
        AddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddressBookCell" forIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self configureAddressBookCell:cell indexPath:indexPath];
        return cell;
    }
}

- (void)configureAddressBookCell: (AddressTableViewCell *)cell indexPath: (NSIndexPath *)indexPath {
    
    cell.fd_enforceFrameLayout = NO;
    if (self.dataArray.count > 0) {
        AddressModel *model = self.dataArray[indexPath.row];
        [cell configureCellWithTitleText:model.contactName subTitleText:[NSString stringWithFormat:@"%@%@",model.area, model.detailAddress]];
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return FLT_EPSILON;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return FLT_EPSILON;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return [tableView fd_heightForCellWithIdentifier:@"AddressBookCell" configuration:^(id cell) {
            [self configureAddressBookCell:cell indexPath:indexPath];
        }];
    } else {
        return 44;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UpdateAddressViewController *updateAddressVc;
        // 注意present要包装个nav过去,否则是不带导航栏的
    if (indexPath.section == 0) {
        updateAddressVc = [[UpdateAddressViewController alloc]initWithUpdateAddressViewControllerWithAddressModel:self.dataArray[indexPath.row]];
    } else {
        updateAddressVc = [[UpdateAddressViewController alloc]initWithUpdateAddressViewControllerWithAddressModel:nil];
    }
    updateAddressVc.navigationItem.title = @"修改地址";
    updateAddressVc.block = ^{
      // 刷新数据
        [self readData];
    };
    BaseNavigationController *nav = [[BaseNavigationController alloc]initWithRootViewController:updateAddressVc];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

#pragma mark - UITableViewEditing

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewCellEditingStyleDelete;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.deleteIndexPath = indexPath;
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSLog(@"删除...");
        [self deleteAction];
    }
}

#pragma mark - Private Method

- (void)deleteAction {
    
    WLAlertViewController *alertVc = [[WLAlertViewController alloc]initWithTitle:@"确定要删除么?" message:nil delegate:self cancelButtonTitle:@"取消" preferredStyle:WLAlertControllerStyleAlert];
    [alertVc addOtherButtonWithTitle:@"删除" style:WLAlertActionStyleDestructive];
    [alertVc show];
}

#pragma mark - WLAlertViewControllerDelegate

- (void)WLAlertView:(WLAlertViewController *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        // 1.先删除数据库数据
        [[AddAddressManager shareInstance]deleteAddressInfoWithModel:self.dataArray[self.deleteIndexPath.row]];
        // 2.刷新表视图
        NSIndexSet *indesSet = [NSIndexSet indexSetWithIndex:0];
        [self.tableView reloadSections:indesSet withRowAnimation:UITableViewRowAnimationNone];
    }
}

#pragma mark - 懒加载

- (NSMutableArray *)dataArray {
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
