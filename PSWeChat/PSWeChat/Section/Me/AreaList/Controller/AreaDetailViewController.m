//
//  AreaDetailViewController.m
//  PSWeChat
//
//  Created by 思 彭 on 2017/4/24.
//  Copyright © 2017年 思 彭. All rights reserved.
//

#import "AreaDetailViewController.h"
#import "LabelTableViewCell.h"
#import "PersonalInfoViewController.h"

@interface AreaDetailViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation AreaDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

#pragma mark - 设置界面

- (void)setUI {
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, K_SCREEN_WIDTH, K_SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.tableFooterView = [[UIView alloc]init];
    // 注册cell
    [self.tableView registerClass:[LabelTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview: self.tableView];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.areaArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LabelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    [cell configureLeftLabelText:self.areaArray[indexPath.row] rightLabeltext:@""];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.0001f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return @"全部";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    [self.navigationController popToViewController:[PersonalInfoViewController new] animated:YES];
    // 取得"个人信息"控制器pop
    id vc = self.navigationController.viewControllers[self.navigationController.viewControllers.count - 3];
    // 发通知修改个人信息-地区信息
    [[NSNotificationCenter defaultCenter]postNotificationName:SelectAreaSuccessNotification object:nil userInfo:@{@"selectArea" : self.areaArray[indexPath.row]}];
    [self.navigationController popToViewController:vc animated:YES];
}

@end
