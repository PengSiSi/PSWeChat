//
//  ChatRoomViewController.m
//  PSWeChat
//
//  Created by 思 彭 on 2017/4/16.
//  Copyright © 2017年 思 彭. All rights reserved.
//

#import "ChatRoomViewController.h"
#import "UINavigationBar+Awesome.h"
#import "TRRTuringRequestManager.h"
#import "TextMessageTableViewCell.h"
#import <UITableView+FDTemplateLayoutCell.h>
#import "TextMessageTableViewCell.h"
#import "Message.h"
#import "DateUtil.h"
#import "EditorView.h"
#import <IQKeyboardManager.h>
#import "LGMessageModel.h"
#import "LGAudioKit.h"

#define SOUND_RECORD_LIMIT 60
#define DocumentPath  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

static NSInteger const kEditorHeight = 50;
static NSUInteger const kShowSendTimeInterval = 60;

@interface ChatRoomViewController ()<EditorViewDelegate>

@property (strong, nonatomic) UITableView* tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) EditorView *editorView;
@property (nonatomic, weak) NSTimer *timerOf60Second;

@end

@implementation ChatRoomViewController

#pragma mark - Life Cycle

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    // 视图出现,tableView滑到底部
    [self scrollToBottom:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"思思";
    [IQKeyboardManager sharedManager].enable = NO;
    [self setUI];
    [self setupEditorView];
    [self addSubViewsConstraints];
    [self loadData];
    [self addRefresh];
}

+ (NSUInteger)editorViewHeight {
    
    return kEditorHeight;
}

#pragma mark - 刷新

- (void)addRefresh {
    
    //下拉刷新控件
    MJRefreshNormalHeader* header =
    [MJRefreshNormalHeader headerWithRefreshingBlock:^{

        [self loadData];
    }];
    header.lastUpdatedTimeLabel.hidden = true;
    header.stateLabel.hidden = true;
    self.tableView.mj_header = header;
    
//    // 模拟结束刷新数据
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        
//        [self.tableView.mj_header endRefreshing];
//    });
}

#pragma mark - 加载数据

// 模拟数据
- (void)loadData {
    
    for (NSInteger i = 0 ; i < 20; i++) {
        Message *message = [[Message alloc]init];
        message.message = @"思思,今天是4月27日,早上好啊";
        message.sendTime = kShowSendTimeInterval;
        if (i == 0) {
            message.showSendTime = YES;
        } else {
            message.showSendTime = NO;
        }
        [self.dataArray addObject:message];
    }
    [self.tableView.mj_header endRefreshing];
    [self.tableView reloadData];
}

#pragma mark - 设置界面

- (void)setupEditorView {
    
    if (self.editorView) {
        return;
    }
    self.editorView = [EditorView editorView];
    self.editorView.delegate = self;
    
    [self.view addSubview:self.editorView];
    __weak typeof(self) weakSelf = self;
    
    // 监听键盘弹出,隐藏操作
    self.editorView.keyBoardWillShow = ^(NSInteger animCurveKey, CGFloat duration, CGSize keyboardSize) {
        
        // 若要在修改约束的同时进行动画的话，需要调用其父视图的layoutIfNeeded方法，并在动画中再调用一次
        if (keyboardSize.height == 0) {
            return;
        }
        [weakSelf.editorView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.offset(-keyboardSize.height);
        }];
        [weakSelf.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.offset(-keyboardSize.height - kEditorHeight);
        }];
        [UIView animateWithDuration:duration
                              delay:0
                            options:animCurveKey
                         animations:^{
                             [weakSelf.view layoutIfNeeded];
                             
                             //滚动动画必须在约束动画之后执行，不然会被中断
                             [weakSelf scrollToBottom:YES];
                         }
                         completion:nil];
    };
    self.editorView.keyboardWillHidden = ^(NSInteger animCurveKey, CGFloat duration, CGSize keyboardSize) {
        
        [weakSelf.view layoutIfNeeded];
        [weakSelf.editorView mas_updateConstraints:^(MASConstraintMaker* make) {
            make.bottom.offset(0);
        }];
        [weakSelf.tableView mas_updateConstraints:^(MASConstraintMaker* make) {
            make.bottom.offset(-kEditorHeight);
        }];

    };
    
    // 发送消息
    self.editorView.messageWasSend = ^(id message, ChatMessageType type) {
        // 包装一个model
        Message *model = [[Message alloc]init];
        model.message = message;
        [weakSelf.dataArray addObject:model];
        // 直接刷新tableView看不到最后发送消息的cell了,需要更新行
//        [weakSelf.tableView reloadData];
        [weakSelf updateNewOneRowInTableview];
    };
    
    // 发送语音
    self.editorView.voiceButtonClick = ^{
        
        // 开始录音
    };
}

- (void)updateNewOneRowInTableview {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.dataArray.count - 1 inSection:0];
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
    // 更新完表视图,一定要滑动到表视图底部
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)setUI {
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, K_SCREEN_WIDTH, K_SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.backgroundColor = [UIColor colorWithWhite:.95 alpha:1];
    // 注册cell
    [self.tableView registerClass:[TextMessageTableViewCell class]
           forCellReuseIdentifier:kCellIdentifierLeft];
    [self.tableView registerClass:[TextMessageTableViewCell class]
           forCellReuseIdentifier:kCellIdentifierRight];
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview: self.tableView];
}

- (void)addSubViewsConstraints {
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.left.right.offset(0);
        make.bottom.offset(-kEditorHeight);
    }];
    [self.editorView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.bottom.offset(0);
        make.height.offset(kEditorHeight);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *identify = [self chatRoomIdentifyer:indexPath];
    TextMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return FLT_EPSILON;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return FLT_EPSILON;
}

- (CGFloat)tableView: (UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    Message *model = self.dataArray[indexPath.row];
    if (model.showSendTime) {
        return 100;
    }
    return 80;
}

- (void)scrollToBottom: (BOOL)animated {
    
    if (self.dataArray.count == 0) {
        return;
    }
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArray.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:animated];
}

- (NSString *)chatRoomIdentifyer: (NSIndexPath *)indexPath {
    
    if (indexPath.row % 2 == 0) {
        return kCellIdentifierRight;
    } else {
        return kCellIdentifierLeft;
    }
}

#pragma mark - EditorViewDelegate

- (void)editorViewStartRecordVoice {
    NSLog(@"开始录制");
    __block BOOL isAllow = 0;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
        [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
            if (granted) {
                isAllow = 1;
            } else {
                isAllow = 0;
            }
        }];
    }
    if (isAllow) {
        //		//停止播放
        [[LGAudioPlayer sharePlayer] stopAudioPlayer];
        //		//开始录音
        [[LGSoundRecorder shareInstance] startSoundRecord:self.view recordPath:[self recordPath]];
        //开启定时器
        if (_timerOf60Second) {
            [_timerOf60Second invalidate];
            _timerOf60Second = nil;
        }
        _timerOf60Second = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(sixtyTimeStopAndSendVedio) userInfo:nil repeats:YES];
    } else {
        
    }
}

- (void)editorViewCancelRecordVoice {
    NSLog(@"取消录制");
    [[LGSoundRecorder shareInstance] soundRecordFailed:self.view];
}

- (void)editorViewConfirmRecordVoice {
    
    NSLog(@"确认录制完成");
    if ([[LGSoundRecorder shareInstance] soundRecordTime] == 0) {
        [self editorViewCancelRecordVoice];
        return;//60s自动发送后，松开手走这里
    }
    if ([[LGSoundRecorder shareInstance] soundRecordTime] < 1.0f) {
        if (_timerOf60Second) {
            [_timerOf60Second invalidate];
            _timerOf60Second = nil;
        }
        [self showShotTimeSign];
        return;
    }
    
    [self sendSound];
    [[LGSoundRecorder shareInstance] stopSoundRecord:self.view];
    
    if (_timerOf60Second) {
        [_timerOf60Second invalidate];
        _timerOf60Second = nil;
    }
}

- (void)editorViewUpdateCancelRecordVoice {
    
    [self updateCancelRecordVoice];
}
- (void)editorViewUpdateContinueRecordVoice {
    
    [self updateContinueRecordVoice];
}

#pragma mark - 录音相关

/**
 *  录音时间短
 */
- (void)showShotTimeSign {
    [[LGSoundRecorder shareInstance] showShotTimeSign:self.view];
}

- (void)sixtyTimeStopAndSendVedio {
    int countDown = SOUND_RECORD_LIMIT - [[LGSoundRecorder shareInstance] soundRecordTime];
    NSLog(@"countDown is %d soundRecordTime is %f",countDown,[[LGSoundRecorder shareInstance] soundRecordTime]);
    if (countDown <= 10) {
        [[LGSoundRecorder shareInstance] showCountdown:countDown];
    }
    if ([[LGSoundRecorder shareInstance] soundRecordTime] >= SOUND_RECORD_LIMIT && [[LGSoundRecorder shareInstance] soundRecordTime] <= SOUND_RECORD_LIMIT + 1) {
        
        if (_timerOf60Second) {
            [_timerOf60Second invalidate];
            _timerOf60Second = nil;
        }
        [self.editorView.recordButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
}

/**
 *  更新录音显示状态,手指向上滑动后 提示松开取消录音
 */
- (void)updateCancelRecordVoice {
    [[LGSoundRecorder shareInstance] readyCancelSound];
}

/**
 *  更新录音状态,手指重新滑动到范围内,提示向上取消录音
 */
- (void)updateContinueRecordVoice {
    [[LGSoundRecorder shareInstance] resetNormalRecord];
}

/**
 *  语音文件存储路径
 *
 *  @return 路径
 */
- (NSString *)recordPath {
    NSString *filePath = [DocumentPath stringByAppendingPathComponent:@"SoundFile"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSError *error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:NO attributes:nil error:&error];
        if (error) {
            NSLog(@"%@", error);
        }
    }
    return filePath;
}

- (void)sendSound {
    LGMessageModel *messageModel = [[LGMessageModel alloc] init];
    messageModel.soundFilePath = [[LGSoundRecorder shareInstance] soundFilePath];
    messageModel.seconds = [[LGSoundRecorder shareInstance] soundRecordTime];
    [self.dataArray addObject:messageModel];
    NSLog(@"录音条数为: %ld,时间是:%f path = %@",self.dataArray.count,messageModel.seconds, messageModel.soundFilePath);
}

#pragma mark - 懒加载

- (NSMutableArray *)dataArray {
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
