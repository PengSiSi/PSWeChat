//
//  ShareAddViewController.m
//  PSWeChat
//
//  Created by 思 彭 on 2017/4/19.
//  Copyright © 2017年 思 彭. All rights reserved.
//

#import "ShareAddViewController.h"
#import "ContentTextView.h"
#import "SelectPhotoView.h"
#import "AddTextAndPhotoView.h"
#import "AddShareTableViewCell.h"
#import "PKPlayerView.h"
#import "MWPhotoBrowser.h"
#import "WLAlertViewController.h"
#import "LocationViewController.h"

#define IMAGE_SPACE (10)
#define IMAGE_COLUMN_NUM (4)
#define IMAGE_WIDTH (K_SCREEN_WIDTH - (IMAGE_COLUMN_NUM+1)*IMAGE_SPACE)/IMAGE_COLUMN_NUM
#define SIGHT_WIDTH (160)

static NSString *const AddShareTableViewCellID = @"AddShareTableViewCell";
@interface ShareAddViewController ()<UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>
{
    UIView *selectView;
    SelectPhotoView *selectPhotoView;
    UIButton *rightBtn;
    NSString *contentStr;
    PKPlayerView *sightPlayer;
}
@property (nonatomic, strong) ContentTextView *contentTextView;
@property (nonatomic, strong) UIView *headerView;;
@property (nonatomic, strong) UIView *selectView;
//@property (nonatomic, strong) SelectPhotoView *selectPhotoView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *imgArray;
@property (nonatomic, strong) NSArray *titleArray;

@property (strong, nonatomic) NSMutableArray *selectImageArray;
@property (strong, nonatomic) NSMutableArray *fileNameArray;
@property (strong, nonatomic) NSMutableArray *useNameArray;

@end

@implementation ShareAddViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self initialData];
    [self createNavItem];
    [self setupUI];
    [self createTableHeaderView];
    
    // 接收修改头视图的高度通知  本来想子类用通知实现,发现有问题,后续优化吧!
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateTableHeaderViewHeight:) name:@"updateShareAddHeaderViewHeight" object:nil];
    
}


#pragma mark - InitialData

- (void)initialData {
    
    self.imgArray = @[@[@"FootStep"], @[@"Shake_icon_tv", @"FootStep"]];
    self.titleArray = @[@[@"所在位置"], @[@"谁可以看", @"提醒谁看"]];
    self.selectImageArray = [NSMutableArray array];
    self.fileNameArray = [NSMutableArray array];
    self.useNameArray = [NSMutableArray array];
}

#pragma mark - 设置界面

- (void)createNavItem {
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancleAction)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(sendAction)];
    self.navigationItem.rightBarButtonItem.tintColor = kThemeColor; // 绿色
}

#pragma mark - 设置界面

- (void)setupUI {
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, K_SCREEN_WIDTH, K_SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    // 注册cell
    [self.tableView registerClass:[AddShareTableViewCell class] forCellReuseIdentifier:AddShareTableViewCellID];
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview: self.tableView];
}

- (void)createTableHeaderView {
    
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, K_SCREEN_WIDTH, 400)];
    self.headerView.backgroundColor = [UIColor whiteColor];
    //备注TextView
    self.contentTextView = [[ContentTextView alloc] initWithFrame:CGRectMake(10, 0, K_SCREEN_WIDTH - 20, 120)];
    self.contentTextView.showsVerticalScrollIndicator = NO;
    self.contentTextView.returnKeyType = UIReturnKeyDone;
    self.contentTextView.placeholder = @"这一刻的想法...";
    self.contentTextView.placeholderColor = PLACEHOLDER_COLOR;
    self.contentTextView.delegate = self;
    self.contentTextView.font = FONT_16;
    [self.headerView addSubview:self.contentTextView];
    if (_shareType == SharePhotoType) { //图片View
        [self createPhotoAddView];
    } else if (_shareType == ShareSightType) {//小视频View
//        [self createSightAddView];
    }
}

//创建图片进入的新增View
- (void)createPhotoAddView {
    selectView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.contentTextView.frame), K_SCREEN_WIDTH, 300)];
    selectView.backgroundColor = [UIColor whiteColor];
    [self.headerView addSubview:selectView];

    // 注意:图片不存在,插入数组nil,会导致崩溃
    selectPhotoView = [[SelectPhotoView alloc] initWithItemSize:CGSizeMake(IMAGE_WIDTH, IMAGE_WIDTH) placeholderImage:@[[UIImage imageNamed:@"AlbumAddBtn"]].mutableCopy selectPhotoMaxCount:9 passImageArray:_passImageDict[@"selectImage"] spaceOfline:10];
    selectPhotoView.frame = CGRectMake(0, 0, CGRectGetWidth(selectView.frame) , CGRectGetHeight(selectView.frame));
    selectPhotoView.backgroundColor = [UIColor whiteColor];
    [selectView addSubview:selectPhotoView];
    
    __weak typeof(self) weakSelf = self;
    [selectPhotoView setPresentBlock:^(id presentVC) {
        if ([presentVC isKindOfClass:[MWPhotoBrowser class]]) {
            weakSelf.navigationController.navigationBar.titleTextAttributes = @{
                                                                                NSFontAttributeName: [UIFont boldSystemFontOfSize:18],
                                                                                NSForegroundColorAttributeName: [UIColor whiteColor],
                                                                                };
            [weakSelf.navigationController pushViewController:presentVC animated:YES];
        }else {
            [weakSelf.navigationController presentViewController:presentVC animated:YES completion:nil];
        }
    }];
    
    [selectPhotoView setDismissBlock:^(id dismissVC) {
        if ([dismissVC isKindOfClass:[MWPhotoBrowser class]]) {
            weakSelf.navigationController.navigationBar.titleTextAttributes = @{
                                                                                NSFontAttributeName: [UIFont boldSystemFontOfSize:18],
                                                                                NSForegroundColorAttributeName: [UIColor blackColor],
                                                                                };
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }else {
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        }
    }];
    
    [selectPhotoView setSelectImageBlock:^(NSMutableArray *imageArray, NSMutableArray *fileNameArray, NSMutableArray *sizeArray, NSMutableArray *userNameArray) {
        if (weakSelf.selectImageArray.count > 0) {
            [weakSelf.selectImageArray removeAllObjects];
        }
        if (weakSelf.fileNameArray.count > 0) {
            [weakSelf.fileNameArray removeAllObjects];
        }
        if (weakSelf.useNameArray.count > 0) {
            [weakSelf.useNameArray removeAllObjects];
        }
        [weakSelf.selectImageArray addObjectsFromArray:imageArray];
        [weakSelf.fileNameArray addObjectsFromArray:fileNameArray];
        [weakSelf.useNameArray addObjectsFromArray:userNameArray];
        [weakSelf changeHeaderViewFrame];
    }];
    [self changeHeaderViewFrame];
}

- (void)changeHeaderViewFrame {
    NSInteger row = 0;
    if (_selectImageArray.count + 1 < 5) {
        row = 1;
    } else if (_selectImageArray.count + 1 > 4 && _selectImageArray.count + 1 < 9) {
        row = 2;
    } else {
        row = 3;
    }
    self.headerView.frame = CGRectMake(0, 0, K_SCREEN_WIDTH, CGRectGetHeight(self.contentTextView.frame) + IMAGE_WIDTH * row + 10 * row +1);
    selectView.frame = CGRectMake(0, CGRectGetMaxY(self.contentTextView.frame), K_SCREEN_WIDTH, IMAGE_WIDTH*row + 10*(row - 1) + 1);
    selectPhotoView.frame = CGRectMake(0, 0, CGRectGetWidth(selectView.frame), CGRectGetHeight(selectView.frame));
    _tableView.tableHeaderView = self.headerView;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.imgArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return ((NSArray *)self.imgArray[section]).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AddShareTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AddShareTableViewCellID forIndexPath:indexPath];
    [self configureAddShareTableViewCell:cell indexPath:indexPath];
    return cell;
}

- (void)configureAddShareTableViewCell: (AddShareTableViewCell *)cell indexPath: (NSIndexPath *)indexPath {
    
    NSArray *imgArr = self.imgArray[indexPath.section];
    NSArray *titleArr = self.titleArray[indexPath.section];
    [cell configureAddShareTableViewCellWithImageName:imgArr[indexPath.row] title:titleArr[indexPath.row]];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return FLT_EPSILON;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 10.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            // 所在位置
            LocationViewController *locationVc = [[LocationViewController alloc]init];
            [self.navigationController pushViewController:locationVc animated:YES];
        }
    }
}

#pragma mark - TextViewDelegate

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    [textView resignFirstResponder];
    return YES;
}

#pragma mark - Private Method

- (void)cancleAction {
    
    WLAlertViewController *alertVc = [[WLAlertViewController alloc]initWithTitle:@"退出此次编辑" message:nil delegate:self cancelButtonTitle:@"取消" preferredStyle:WLAlertControllerStyleAlert];
    [alertVc addOtherButtonWithTitle:@"退出" style:WLAlertActionStyleDefault];
    [alertVc show];
}

- (void)WLAlertView:(WLAlertViewController *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        
    } else {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)sendAction {
    
}

#pragma mark - NotificatonAction

- (void)updateTableHeaderViewHeight: (NSNotification *)notification {
    
    CGFloat height = [notification.userInfo[@"headerViewHeight"] floatValue];
    self.headerView.frame = CGRectMake(0, 0, K_SCREEN_WIDTH - 20, height);
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}



@end
