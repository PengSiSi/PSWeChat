//
//  AddContractTagViewController.m
//  PSWeChat
//
//  Created by 思 彭 on 2017/5/2.
//  Copyright © 2017年 思 彭. All rights reserved.
//

#import "AddContractTagViewController.h"
#import "SelectContractViewController.h"
#import "BaseNavigationController.h"

@interface AddContractTagViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataMutableArray;

@end

@implementation AddContractTagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"标签";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveAction)];
    self.navigationItem.rightBarButtonItem.tintColor = kThemeColor;
    [self setUI];
}

#pragma mark - 设置界面

- (void)setUI {
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, K_SCREEN_WIDTH, K_SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = [[UIView alloc]init];
    // 注册cell
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview: self.tableView];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 1;
    }
    return self.dataMutableArray.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        ;
        // 注意: 这种写法上面不能注册cell,否则cell的子控件将不会显示!!!
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            // textFields
            UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, K_SCREEN_WIDTH - 20, 44)];
            textField.placeholder = @"未设置标签名字";
            textField.font = FONT_16;
            [cell.contentView addSubview:textField];
        }
        return cell;
    } else {
        UITableViewCell *addCell = [tableView dequeueReusableCellWithIdentifier:@"addCell"];
        addCell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (!addCell) {
            addCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"addCell"];
        }
        // 注意要在if语句外面写,否则子控件赋值不显示.
        addCell.imageView.image = [UIImage imageNamed:@"form_add"];
        addCell.textLabel.font = FONT_15;
        addCell.textLabel.text = @"添加成员";
        addCell.textLabel.textColor = kThemeColor;
        return addCell;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.0001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return @"标签名字";
    } else {
        return @"标签成员(0)";
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        // 选择联系人
        SelectContractViewController *selectContractVc = [SelectContractViewController new];
        BaseNavigationController *nav = [[BaseNavigationController alloc]initWithRootViewController:selectContractVc];
        [self presentViewController:nav animated:YES completion:nil];
    }
}

#pragma mark - Private Method

- (void)saveAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
