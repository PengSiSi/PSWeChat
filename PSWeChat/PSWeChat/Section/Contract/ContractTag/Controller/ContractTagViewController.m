//
//  ContractTagViewController.m
//  PSWeChat
//
//  Created by 思 彭 on 2017/5/2.
//  Copyright © 2017年 思 彭. All rights reserved.
//

#import "ContractTagViewController.h"
#import "AddContractTagViewController.h"

static NSString *const AddTagCellID = @"addTagCell";
static NSString *const DetailTagCellID = @"detailTagCell";

@interface ContractTagViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation ContractTagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"标签";
    // 更改左侧的返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"< 返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    [self initializationData];
    [self setUI];
}

#pragma mark - Initialization Data

- (void)initializationData {
   
    self.dataArray = [@[@"", @"", @"", @""] mutableCopy];
}

#pragma mark - 设置界面

- (void)setUI {
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, K_SCREEN_WIDTH, K_SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    // 注册cell
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:AddTagCellID];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:DetailTagCellID];
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview: self.tableView];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        UITableViewCell *addTagCell = [tableView dequeueReusableCellWithIdentifier:AddTagCellID];
        if (!addTagCell) {
            if (indexPath.row == 0) {
                addTagCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AddTagCellID];
            }
        }
        // 注意要在if语句外面写,否则子控件赋值不显示.
        addTagCell.imageView.image = [UIImage imageNamed:@"form_add"];
        addTagCell.textLabel.font = FONT_15;
        addTagCell.textLabel.text = @"新建标签";
        addTagCell.textLabel.textColor = kThemeColor;
        return addTagCell;
    }
    else {
        UITableViewCell *detailTagCell = [tableView dequeueReusableCellWithIdentifier:DetailTagCellID];
        if (!detailTagCell) {
            detailTagCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DetailTagCellID];
        }
        detailTagCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        detailTagCell.textLabel.text = @"那大学...(2)";
        detailTagCell.textLabel.font = FONT_15;
        detailTagCell.detailTextLabel.font = FONT_15;
        detailTagCell.detailTextLabel.textColor = [UIColor lightGrayColor];
        detailTagCell.detailTextLabel.text = @"思思1,思思2";
        return detailTagCell;
    }
    return nil;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return FLT_EPSILON;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return FLT_EPSILON;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        AddContractTagViewController *addTagVc = [[AddContractTagViewController alloc]init];
        [self.navigationController pushViewController:addTagVc animated:YES];
    }
}

#pragma mark - Private Method 

- (void)back {
   
    [self.navigationController popViewControllerAnimated:YES];
}

@end
