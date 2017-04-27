//
//  UpdateAddressViewController.m
//  PSWeChat
//
//  Created by 思 彭 on 2017/4/20.
//  Copyright © 2017年 思 彭. All rights reserved.
//

#import "UpdateAddressViewController.h"
#import "WLAlertViewController.h"
#import "UpdateAddressTableViewCell.h"
#import "AddAddressManager.h"

static NSString *const CellIdentify = @"cell";

@interface UpdateAddressViewController ()<WLAlertViewControllerDelegate, UITableViewDataSource, UITableViewDelegate, UpdateAddressTableViewCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *imagesNameArray;
@property (nonatomic, strong) NSArray *placeHolderArray;
@property (nonatomic, strong) NSArray *inputContentArray;

@property (nonatomic, strong) AddressModel *model; /**<传过来的model */
@property (nonatomic, strong) AddressModel *currentInputModel; /**<当前输入需要保存的model */
@property (nonatomic, assign) BOOL isInsertAndUpdate; // 1:插入 0:更新

@end

@implementation UpdateAddressViewController

+ (instancetype)updateAddressViewControllerWithAddressModel: (AddressModel *)model {
    
    return [[self alloc]initWithUpdateAddressViewControllerWithAddressModel:model];
}

- (instancetype)initWithUpdateAddressViewControllerWithAddressModel:(AddressModel *)model {
    
    if (self = [super init]) {
        if (model) {
            self.isInsertAndUpdate = NO;
            self.model = model;
        } else {
            self.isInsertAndUpdate = YES;
            self.model = [[AddressModel alloc]init];
        }
    }
    return self;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialUI];
    [self initialData];
    [self setupUI];
}

- (void)initialUI {
    
    self.navigationItem.title = @"修改地址";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancleAction)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveAction)];
    self.navigationItem.rightBarButtonItem.tintColor = kThemeColor;
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

#pragma mark - initData

- (void)initialData {

    self.titleArray = @[@"联系人", @"手机号码", @"选择地区", @"详细地址", @"邮政编码"];
    self.imagesNameArray = @[@"ScanStreet", @"",@"actionbar_location_icon", @"", @""];
    self.placeHolderArray = @[@"名字", @"11位手机号", @"地区信息", @"街道门派信息", @"邮政编码"];
    self.inputContentArray = @[self.model.contactName ? : @"", self.model.telNum ? : @"", self.model.area ? : @"", self.model.detailAddress ? : @"", self.model.zipCode ? : @""];
    self.currentInputModel = [[AddressModel alloc]init];
}

#pragma mark - 设置界面

- (void)setupUI {
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UpdateAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentify forIndexPath:indexPath];
    [self configureCell:cell indexPath:indexPath];
    return cell;
}

- (void)configureCell: (UpdateAddressTableViewCell *)cell indexPath: (NSIndexPath *)indexPath {
    
    cell.delegate = self;
    cell.inputTextField.tag = indexPath.row;
    if (indexPath.row == 0 || indexPath.row == 2 ) {
        cell.rightButton.hidden = NO;
    }
    if (!self.isInsertAndUpdate) { // yes是插入
        cell.inputTextField.text = self.inputContentArray[indexPath.row];
    } else {
        cell.inputTextField.placeholder = self.placeHolderArray[indexPath.row];
    }
    [cell configureUpdateAddressTableViewCellWithTitleLabelText:self.titleArray[indexPath.row] rightImageName:self.imagesNameArray[indexPath.row]];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return FLT_EPSILON;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10.0f;
}

#pragma mark - UpdateAddressTableViewCellDelegate

- (void)addTableViewCellWithLabelAndTextField:(UITableViewCell *)cell textFieldDidEndEditing:(UITextField *)textField {
    
    NSInteger inputTextFieldTag = ((UpdateAddressTableViewCell *)cell).inputTextField.tag;
    switch (inputTextFieldTag) {
        case 0:
            self.model.contactName = textField.text;
            break;
        case 1:
            self.model.telNum = textField.text;
            break;
        case 2:
            self.model.area = textField.text;
            break;
        case 3:
            self.model.detailAddress = textField.text;
            break;
        case 4:
            self.model.zipCode = textField.text;
            break;
        default:
            break;
    }
    if (self.model.contactName && self.model.telNum && self.model.area && self.model.detailAddress && self.model.zipCode) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
}

#pragma mark - Private Method

- (void)cancleAction {
    
    WLAlertViewController *alertVc = [[WLAlertViewController alloc]initWithTitle:@"退出此次编辑" message:nil delegate:self cancelButtonTitle:@"取消" preferredStyle:WLAlertControllerStyleAlert];
    [alertVc addOtherButtonWithTitle:@"退出" style:WLAlertActionStyleDefault];
    [alertVc show];
}

- (void)saveAction {
    
     if (self.model.contactName && self.model.telNum && self.model.area && self.model.detailAddress && self.model.zipCode) {
         
         if (self.isInsertAndUpdate) {
             // 存到数据库
             AddAddressManager *manager = [AddAddressManager shareInstance];
             [manager saveAddressInfoWithModel:self.model];
             if (self.block) {
                 self.block();
             }
         } else {
             // 更新
             AddAddressManager *manager = [AddAddressManager shareInstance];
             [manager updateAddressInfoWithModel:self.model];
             if (self.block) {
                 self.block();
             }
         }
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    } else {
        [CombancHUD showInfoWithStatus:@"请输入完整信息"];
        return;
    }
}

- (void)WLAlertView:(WLAlertViewController *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
    } else {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - 懒加载

- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate  =self;
        _tableView.dataSource = self;
        // 注册cell
        [_tableView registerClass:[UpdateAddressTableViewCell class] forCellReuseIdentifier:CellIdentify];
        _tableView.tableFooterView = [[UIView alloc]init];
    }
    return _tableView;
}

@end
