//
//  FriendCircleViewController.m
//  PSWeChat
//
//  Created by 思 彭 on 2017/4/14.
//  Copyright © 2017年 思 彭. All rights reserved.
//

#import "FriendCircleViewController.h"
#import "MessageModel.h"
#import "CommentModel.h"
#import "YYFPSLabel.h"
#import "ShareTableViewCell.h"
#import <UITableView+FDTemplateLayoutCell.h>
#import "CoverHeaderView.h"
#import "SpinningLoadingView.h"
#import "WFPopView.h"
#import "YMReplyInputView.h"
//键盘
#import "ChatKeyBoard.h"
#import <IQKeyboardManager.h>
#import "SelectFileManager.h"
#import "ShareAddViewController.h"

static NSUInteger const kCoverViewHeight = 450;
#define defaultContentHeight (getHeight(57.5))
#define replyTextFieldHeigth (getHeight(44))

@interface FriendCircleViewController ()<UITableViewDelegate, UITableViewDataSource,InputDelegate, ChatKeyBoardDelegate,ChatKeyBoardDataSource, UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) CoverHeaderView *coverView;
@property (assign, nonatomic) float contentInsetY;
@property (nonatomic, strong) WFPopView *operationView;
@property (nonatomic, strong) YMReplyInputView *replyView;/**<回复 */
@property (nonatomic, strong) ChatKeyBoard *chatKeyBoard;
@property (nonatomic,copy) NSIndexPath *currentIndexPath;
//专门用来回复选中的cell的model
@property (nonatomic, strong) CommentModel *replayTheSeletedCellModel;
@property (nonatomic, assign) BOOL needUpdateOffset;//控制是否刷新table的offset
@property (nonatomic, assign) BOOL isShowKeyBoard;//记录点击cell的高度，高度由代理传过来
@property (nonatomic, assign) CGFloat history_Y_offset;//记录table的offset.y

// 发布选择图片数组
@property (strong, nonatomic) NSMutableArray *selectImageArray;
@property (strong, nonatomic) NSMutableArray *fileNameArray;
@property (strong, nonatomic) NSMutableArray *useNameArray;

@end

@implementation FriendCircleViewController

#pragma mark - init

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        //注册键盘出现NSNotification
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification object:nil];
        
        
        //注册键盘隐藏NSNotification
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (NSArray<ChatToolBarItem *> *)chatKeyBoardToolbarItems
{
    ChatToolBarItem *item1 = [ChatToolBarItem barItemWithKind:kBarItemFace normal:@"face" high:@"face_HL" select:@"keyboard"];
    ChatToolBarItem *item2 = [ChatToolBarItem barItemWithKind:kBarItemVoice normal:@"voice" high:@"voice_HL" select:@"keyboard"];

    ChatToolBarItem *item3 = [ChatToolBarItem barItemWithKind:kBarItemMore normal:@"more_ios" high:@"more_ios_HL" select:nil];

    ChatToolBarItem *item4 = [ChatToolBarItem barItemWithKind:kBarItemSwitchBar normal:@"switchDown" high:nil select:nil];
    return @[item1, item2, item3, item4];
}

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.contentInsetY = -150;
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    self.navigationItem.title = @"朋友圈";
    [self setupRightItem];
    [self dealData];
    [self setupUI];
    [self addRefresh];
    _operationView = [WFPopView initailzerWFOperationView];
}
/*
 Mark:
 tableView似乎只认tableHeaderView的frame，不认约束，所以要在这里用systemLayoutSizeFittingSize算出约束高度后再重新赋值给tableHeaderView
 */
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    CoverHeaderView* headerView = (CoverHeaderView *)self.tableView.tableHeaderView;
    
    /*
     黑历史：systemLayoutSizeFittingSize算出来有700多，没办法只有设成死值了
     实际原因是因为我没有给coverView添加Bottom约束，所以算出来的值不对
     */
    CGFloat height = [headerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    CGRect frame = headerView.frame;
    frame.size.height = height;
    headerView.frame = frame;
    self.tableView.tableHeaderView = headerView;
}

#pragma mark - 设置界面

- (void)setupRightItem{

//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:[[YYFPSLabel alloc]initWithFrame:CGRectMake(0, 5, 60, 30)]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"photograph_icon"] style:UITableViewStylePlain target:self action:@selector(publishShareAction:)];
}

- (void)setupUI {
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    // 顶部遮挡
    self.tableView.contentInset = UIEdgeInsetsMake(self.contentInsetY, 0, 0, 0);
    // 设置封面view
    self.coverView = [CoverHeaderView coverHeaderViewWithCoverImage:[UIImage imageNamed:@"cover"] name:@"思思" avater:[UIImage imageNamed:@"test1"]];
//    self.coverView.layer.borderWidth = 0.0f;
//    self.coverView.layer.borderColor = [UIColor clearColor].CGColor;
    self.tableView.tableHeaderView = self.coverView;
    [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.top.offset(0);
        make.width.mas_equalTo(self.view);
        make.height.mas_equalTo(kCoverViewHeight);;
        make.bottom.offset(0);
    }];
}

#pragma mark - 添加刷新

- (void)addRefresh {
    
    // 下拉刷新
    SpinningLoadingView *loadingView = [SpinningLoadingView headerWithRefreshingBlock:^{
       
        // 模拟延时
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self dealData];
                [self.tableView reloadData];
                [self.tableView.mj_header endRefreshing];
            });
        });
    }];
    loadingView.ignoredScrollViewContentInsetTop = self.contentInsetY;
    self.tableView.mj_header = loadingView;
    
    // 上拉加载
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        dispatch_after(
           dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(),
           ^{
               [self dealData];
               [self.tableView.mj_footer endRefreshing];
           });
    }];
}

#pragma mark - 数据处理

-(void)dealData{
    self.dataArray = [[NSMutableArray alloc]init];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"]]];
    NSDictionary *JSONDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    for (NSDictionary *eachDic in JSONDic[@"data"][@"rows"]) {
        MessageModel *messageModel = [[MessageModel alloc] initWithDic:eachDic];
        [self.dataArray addObject:messageModel];
    }
    /*
     tableview.header默认是在tableview.tableHeaerView后面的
     而且每次更新表格后都会重置这个顺序，所以每次刷新都要执行一次这个方法
     */
    [self.tableView bringSubviewToFront:self.tableView.mj_header];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShareTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ShareTableViewCell class]) forIndexPath:indexPath];
    MessageModel *model = [self.dataArray objectAtIndex:indexPath.row];
    [self configureShareTableViewCell:cell model:model indexPath:indexPath];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageModel *messageModel = [self.dataArray objectAtIndex:indexPath.row];
    return [tableView fd_heightForCellWithIdentifier:NSStringFromClass([ShareTableViewCell class]) configuration:^(ShareTableViewCell *cell) {
        [cell configCellWithModel:messageModel indexPath:indexPath];
    }];
}

#pragma mark - ConfigureCell

- (void)configureShareTableViewCell: (ShareTableViewCell *)cell model: (MessageModel *)model indexPath: (NSIndexPath *)indexPath {
    
    __weak typeof(self) weakSelf = self;
    
    [cell configCellWithModel:model indexPath:indexPath];
    // 更多block
    cell.MoreBtnClickBlock = ^(UIButton *moreBtn, NSIndexPath *indexPath) {
        model.isExpand = !model.isExpand;
        [weakSelf.chatKeyBoard keyboardDownForComment];
        [weakSelf.tableView reloadData];
    };
    // 九宫格block
    cell.tapImageBlock = ^(NSInteger index, NSArray *dataSource, NSIndexPath *indexpath) {
        [weakSelf.chatKeyBoard keyboardDownForComment];
    };
    
    // 评论,点赞
    cell.ReplyBtnClickBlock = ^(UIButton *replyBtn, NSIndexPath *indexPath) {
        
        [weakSelf.chatKeyBoard keyboardDownForComment];
        // 回复内容
        CGRect rectInTableView = [_tableView rectForRowAtIndexPath:indexPath];
        CGFloat origin_Y = rectInTableView.origin.y + replyBtn.frame.origin.y;
        CGRect targetRect = CGRectMake(CGRectGetMinX(replyBtn.frame), origin_Y, CGRectGetWidth(replyBtn.bounds), CGRectGetHeight(replyBtn.bounds));
        if (self.operationView.shouldShowed) {
            [self.operationView dismiss];
            return;
        }
        BOOL favour = model.hasOk;
        self.operationView.tag = indexPath.row;
        [self.operationView showAtView:_tableView rect:targetRect isFavour:favour];
        __weak typeof(self) weakSelf = self;
        __strong typeof(weakSelf) strongSelf = weakSelf;
    
        self.operationView.didSelectedOperationCompletion = ^(WFOperationType operationType) {
            switch (operationType) {
                case WFOperationTypeLike:
                    // 点赞:
                    [strongSelf addLike:indexPath.row];
                    break;
                case WFOperationTypeReply:
                    // 评论
                    [strongSelf replyMessage:indexPath.row];
                    break;
                default:
                    break;
            }
        };
    };
    
    // 回复
    cell.commentCellDidSelectBlock = ^(UITableView *tableView, CommentCell *cell, NSIndexPath *commentIndexPath) {
              
        // 取得这个点击的cell的评论model
        MessageModel *currentModel = weakSelf.dataArray[indexPath.row];
        CommentModel *currentCommentModel = currentModel.commentModelArray[commentIndexPath.row];
        self.replayTheSeletedCellModel = currentCommentModel;
        self.currentIndexPath = indexPath;
        // 开启回复的键盘
        self.chatKeyBoard.placeHolder = [NSString stringWithFormat:@"思思回复%@",currentCommentModel.commentUserName];
        [self.chatKeyBoard keyboardUpforComment];
    };
    
    // 删除
    cell.DeleteBtnClickBlock = ^(UIButton *deleteBtn, NSIndexPath *indexPath) {
        // 取得这个点击的cell的评论model
        MessageModel *currentModel = weakSelf.dataArray[indexPath.row];
        [self.dataArray removeObject:currentModel];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView reloadData];
    };
}

#pragma mark - 点赞,评论

- (void)addLike: (NSInteger)sender {
    
    MessageModel *model = self.dataArray[sender];
    model.hasOk = !model.hasOk;
    [self.tableView reloadData];
}

- (void)replyMessage:(NSInteger)sender {
    
    if (self.replyView) {
        return;
    }
    self.replyView = [[YMReplyInputView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - replyTextFieldHeigth, K_SCREEN_WIDTH,replyTextFieldHeigth) andAboveView:self.view];
    self.replyView.delegate = self;
    self.replyView.replyTag = sender;
    [self.view addSubview:self.replyView];
}

#pragma mark - InputDelegate

- (void)YMReplyInputWithReply:(NSString *)replyText appendTag:(NSInteger)inputTag {
    
    MessageModel *model = self.dataArray[inputTag];
    //进行评论
    // 构造model
    CommentModel *commentModel = [[CommentModel alloc]init];
    commentModel.commentUserId = commentModel.commentUserId = [NSString stringWithFormat:@"%i",[self getRandomNumber:100 to:1000]];;
    commentModel.commentId = commentModel.commentId = [NSString stringWithFormat:@"%i",[self getRandomNumber:100 to:1000]];
    commentModel.commentUserName = @"思思";
    commentModel.commentByUserName = @"";
    commentModel.commentText = replyText;
    [model.commentModelArray addObject:commentModel];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:inputTag inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:
     UITableViewRowAnimationNone];
}

- (void)destorySelf {
    
    [self.replyView removeFromSuperview];
    self.replyView = nil;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self.operationView dismiss];
    [self.chatKeyBoard keyboardDownForComment];
}

#pragma mark - ChatKeyBoardDelegate

- (void)chatKeyBoardSendText:(NSString *)text{
    
     //创建一个新的CommentModel,并给相应的属性赋值，然后加到评论数组的最后，reloadData
    // 取得这个点击的cell的评论model
    MessageModel *messageModel = self.dataArray[self.currentIndexPath.row];
    messageModel.shouldUpdateCache = YES;
    
    CommentModel *commentModel = [[CommentModel alloc]init];
    commentModel.commentUserName = @"思思";
    commentModel.commentUserId = @"274";
    commentModel.commentPhoto = @"http://q.qlogo.cn/qqapp/1104706859/189AA89FAADD207E76D066059F924AE0/100";
    commentModel.commentByUserName = self.replayTheSeletedCellModel?self.replayTheSeletedCellModel.commentUserName:@"";
    commentModel.commentId = [NSString stringWithFormat:@"%i",[self getRandomNumber:100 to:1000]];
    commentModel.commentText = text;
    [messageModel.commentModelArray addObject:commentModel];
    
    messageModel.shouldUpdateCache = YES;
    [self.chatKeyBoard keyboardDownForComment];
    [self.tableView reloadRowsAtIndexPaths:@[self.currentIndexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)chatKeyBoardFacePicked:(ChatKeyBoard *)chatKeyBoard faceStyle:(NSInteger)faceStyle faceName:(NSString *)faceName delete:(BOOL)isDeleteKey{
    NSLog(@"%@",faceName);
}
- (void)chatKeyBoardAddFaceSubject:(ChatKeyBoard *)chatKeyBoard{
    NSLog(@"%@",chatKeyBoard);
}
- (void)chatKeyBoardSetFaceSubject:(ChatKeyBoard *)chatKeyBoard{
    NSLog(@"%@",chatKeyBoard);
    
}

#pragma mark - Private Method

- (void)keyboardWillShow:(NSNotification *)notification {
    //    [_tableView setFrame:CGRectMake(0, kNavbarHeight, kScreenWidth, kScreenHeight)];
    self.isShowKeyBoard = YES;
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    __block  CGFloat keyboardHeight = [aValue CGRectValue].size.height;
    if (keyboardHeight==0) {
        //解决搜狗输入法三次调用此方法的bug、
        //        IOS8.0之后可以安装第三方键盘，如搜狗输入法之类的。
        //        获得的高度都为0.这是因为键盘弹出的方法:- (void)keyBoardWillShow:(NSNotification *)notification需要执行三次,你如果打印一下,你会发现键盘高度为:第一次:0;第二次:216:第三次:282.并不是获取不到高度,而是第三次才获取真正的高度.
        return;
    }
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    CGFloat keyboardTop = keyboardRect.origin.y;
    CGRect newTextViewFrame = self.view.bounds;
    newTextViewFrame.size.height = keyboardTop - self.view.bounds.origin.y;
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    CGFloat delta = 0.0;
    CGPoint offset = self.tableView.contentOffset;
    offset.y += delta;
    if (offset.y < 0) {
        offset.y = 0;
    }
    if (self.needUpdateOffset) {
        [self.tableView setContentOffset:offset animated:YES];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    //    [_tableView setFrame:CGRectMake(0, 20, kScreenWidth, kScreenHeight-kNavbarHeight)];
}

#pragma mark - 发布朋友圈消息

- (void)publishShareAction: (UIBarButtonItem *)barButtonItem {
    
    // 先清除数组
    if (self.selectImageArray.count > 0) {
        [self.selectImageArray removeAllObjects];
    }
    if (self.fileNameArray.count > 0) {
        [self.fileNameArray removeAllObjects];
    }
    if (self.useNameArray.count > 0) {
        [self.useNameArray removeAllObjects];
    }
    __weak typeof(self) weakSelf = self;
    [SelectFileManager sharedInstance].haveSmallVideo = YES;
    [SelectFileManager sharedInstance].showFlatAlertView = YES;
    [[SelectFileManager sharedInstance] selectPhotoAction];
    [SelectFileManager sharedInstance].selectFileMaxCount = 9;
    
    [[SelectFileManager sharedInstance] presentBlock:^(id viewController) {
        if (viewController) {
            [weakSelf.navigationController presentViewController:viewController animated:YES completion:nil];
        }
    }];
    [[SelectFileManager sharedInstance] selectFileBlock:^(NSMutableArray *fileArray, NSMutableArray *nameArray, NSMutableArray *sizeArray, NSMutableArray *userNameArray) {
        weakSelf.selectImageArray = fileArray;
        weakSelf.fileNameArray = nameArray;
        weakSelf.useNameArray = userNameArray;
        
        if (weakSelf.selectImageArray.count > 0) {
            ShareAddViewController *shareAddVC = [[ShareAddViewController alloc] init];
            if ([[weakSelf.selectImageArray firstObject] isKindOfClass:[NSURL class]]) { //视频
                shareAddVC.shareType = ShareSightType;
            } else if ([[weakSelf.selectImageArray firstObject] isKindOfClass:[UIImage class]]) { //图片
                shareAddVC.shareType = SharePhotoType;
            }
            shareAddVC.passImageDict = @{@"selectImage":weakSelf.selectImageArray, @"fileName":weakSelf.fileNameArray, @"useName":weakSelf.useNameArray};
            BaseNavigationController *baseNav = [[BaseNavigationController alloc] initWithRootViewController:shareAddVC];
            [weakSelf.navigationController presentViewController:baseNav animated:YES completion:nil];
            // 添加成功需要刷新数据
            [shareAddVC setAddShareSuccess:^{
                [self beginRefreshing];
            }];
        }
    }];
    [[SelectFileManager sharedInstance] dismissBlock:^(id dismissVC) {
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (void)beginRefreshing {
    
}

#pragma mark - 懒加载

- (UITableView *)tableView {

    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        // 注册cell
        [_tableView registerClass:[ShareTableViewCell class] forCellReuseIdentifier:NSStringFromClass([ShareTableViewCell class])];
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (ChatKeyBoard *)chatKeyBoard{
    
    if (_chatKeyBoard==nil) {
        _chatKeyBoard =[ChatKeyBoard keyBoardWithNavgationBarTranslucent:YES];
        _chatKeyBoard.delegate = self;
        _chatKeyBoard.dataSource = self;
        _chatKeyBoard.keyBoardStyle = KeyBoardStyleComment;
        _chatKeyBoard.allowVoice = NO;
        _chatKeyBoard.allowMore = NO;
        _chatKeyBoard.allowSwitchBar = NO;
        _chatKeyBoard.placeHolder = @"思思回复";
        [self.view addSubview:_chatKeyBoard];
        [self.view bringSubviewToFront:_chatKeyBoard];
    }
    return _chatKeyBoard;
}

#pragma mark - dealloc

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
