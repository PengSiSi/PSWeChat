//
//  SelectFileManager.m
//  Donghuamen
//
//  Created by AlicePan on 17/3/7.
//  Copyright © 2017年 Combanc. All rights reserved.
//

#import "SelectFileManager.h"
#import "WSelectPhoto.h"
#import <CommonCrypto/CommonDigest.h>
#import "HJCActionSheet.h"
#import "KZVideoViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "UIImage+PKShortVideoPlayer.h"
#import "PKShortVideo.h"
#import "LGAudioKit.h"
#import "FileManager.h"
#import "MediaModel.h"

#define SOUND_RECORD_LIMIT 60
#define DocumentPath  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

@interface SelectFileManager()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate, HJCActionSheetDelegate, KZVideoViewControllerDelegate, PKRecordShortVideoDelegate>

@property (strong, nonatomic) UIButton *recordBtn;

@property (nonatomic, weak) NSTimer *timerOf60Second;

@property (nonatomic, strong) NSMutableArray *selectFileArray;/**<选择的图片数组 */
@property (nonatomic, strong) NSMutableArray *fileSizeArray;/**图片的大小 */
@property (nonatomic, strong) NSMutableArray *fileNameArray;/**图片的文件名 */
@property (nonatomic, strong) NSMutableArray *fileUseNameArray;/**图片的重命名 */

@end

@implementation SelectFileManager

static SelectFileManager *manager = nil;
+ (SelectFileManager *)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SelectFileManager alloc] init];
    });
    return manager;
}

- (NSMutableArray *)selectFileArray {
    if (!_selectFileArray) {
        _selectFileArray = [[NSMutableArray alloc] init];
    }
    return _selectFileArray;
}

- (NSMutableArray *)fileNameArray {
    if (!_fileNameArray) {
        _fileNameArray = [[NSMutableArray alloc] init];
    }
    return _fileNameArray;
}

- (NSMutableArray *)fileSizeArray {
    if (!_fileSizeArray) {
        _fileSizeArray = [[NSMutableArray alloc] init];
    }
    return _fileSizeArray;
}

- (NSMutableArray *)fileUseNameArray {
    if (!_fileUseNameArray) {
        _fileUseNameArray = [[NSMutableArray alloc] init];
    }
    return _fileUseNameArray;
}

- (void)selectPhotoAction {
    if (_showFlatAlertView) {
        HJCActionSheet *sheet;
        if (_haveSmallVideo) {
            sheet = [[HJCActionSheet alloc] initWithDelegate:self CancelTitle:@"取消" OtherTitles:@"小视频", @"拍照", @"从手机相册选择", nil];
        } else {
            sheet = [[HJCActionSheet alloc] initWithDelegate:self CancelTitle:@"取消" OtherTitles:@"拍照", @"从手机相册选择", nil];
        }
        
        // 2.显示出来
        [sheet show];
    } else {
        //点击提示选择相机或者相册
        UIActionSheet *actionSheet;
        if (_haveSmallVideo) {
            actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self
                                            cancelButtonTitle:@"取消"
                                       destructiveButtonTitle:nil
                                            otherButtonTitles:@"小视频", @"拍照", @"从手机相册选择",nil];
            actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        } else {
            actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self
                                            cancelButtonTitle:@"取消"
                                       destructiveButtonTitle:nil
                                            otherButtonTitles:@"拍照", @"从手机相册选择",nil];
            actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        }
    
        UIViewController *vc = (UIViewController *)self.superclass;
        [actionSheet showInView:vc.view];
//        [actionSheet showInView:self.view];
    }
}

#pragma mark -UIActionSheet代理方法
// 3.实现代理方法，需要遵守HJCActionSheetDelegate代理协议
- (void)hjcActionSheet:(HJCActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (_haveSmallVideo) {
        if (buttonIndex == 1) {
            [self takeSight];
        } else if (buttonIndex == 2) {
            [self takePhoto];
        }else if (buttonIndex == 3) {
            [self addPhoto];
        }
    } else {
        if (buttonIndex == 1) {
            [self takePhoto];
        } else if (buttonIndex == 2) {
            [self addPhoto];
        }
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (_haveSmallVideo) {
        if (buttonIndex == 0) {
            [self takeSight];
        } else if (buttonIndex == 1) {
            [self takePhoto];
        } else if (buttonIndex == 2) {
            [self addPhoto];
        }
    } else {
        if (buttonIndex == 0) {
            [self takePhoto];
        } else if (buttonIndex == 1) {
            [self addPhoto];
        }
    }
}

#pragma mark - 小视频
- (void)takeSight {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *fileName = [self getSightName];
//    NSLog(@"fileName-----%@", fileName);
    
    NSString *path = [paths[0] stringByAppendingPathComponent:fileName];
    //跳转默认录制视频ViewController
    
    PKRecordShortVideoViewController *recordVC = [[PKRecordShortVideoViewController alloc] initWithOutputFilePath:path outputSize:CGSizeMake(320, 240) themeColor:[UIColor colorWithRed:0/255.0 green:153/255.0 blue:255/255.0 alpha:1]];
    
    //通过代理回调
    recordVC.delegate = self;
    //跳转到相册界面
    if (_presentBlock) {
        _presentBlock(recordVC);
    }
}

#pragma mark - PKRecordShortVideoDelegate
//视频拍摄完成输出图片
- (void)didFinishRecordingToOutputFilePath:(NSString *)outputFilePath {
    
    if (self.fileNameArray.count > 0) {
        [self.fileNameArray removeAllObjects];
    }
    if (self.fileSizeArray.count > 0) {
        [self.fileSizeArray removeAllObjects];
    }
    if (self.fileUseNameArray.count > 0) {
        [self.fileUseNameArray removeAllObjects];
    }
    if (self.selectFileArray.count > 0) {
        [self.selectFileArray removeAllObjects];
    }
    
    NSString *smallVideoPath = outputFilePath;
    
    NSString *originName = [[smallVideoPath componentsSeparatedByString:@"/"] lastObject];
    float sightSize = [FileManager fileSizeAtPath:smallVideoPath];
    
    //视频
    [self.fileNameArray addObject:originName];
    [self.fileSizeArray addObject:[NSString stringWithFormat:@"%f",sightSize/1024.0]];
    [self.fileUseNameArray addObject:originName];
    
    [self.selectFileArray addObject:[NSURL fileURLWithPath:smallVideoPath]];
    
    //封面图片
    //    NSString *coverPhotoName = [self getPhotoName];
    NSString *coverPhotoName = [NSString stringWithFormat:@"%@.JPG", [[originName componentsSeparatedByString:@"."] firstObject]];
    //获取image
    UIImage *coverImage=[UIImage pk_previewImageWithVideoURL:[NSURL fileURLWithPath:smallVideoPath]];
    //压缩图片
    NSData *imageData;
    if (_isCompressImage) {
        imageData = [self compressImage:coverImage];
    } else {
        imageData = UIImagePNGRepresentation(coverImage);
    }
    NSInteger length = [imageData length]/1024; //kb
    
    [self.fileNameArray addObject:coverPhotoName];
    [self.fileSizeArray addObject:[NSString stringWithFormat:@"%ld",(long)length]];
    [self.fileUseNameArray addObject:coverPhotoName];
    [self.selectFileArray addObject:[UIImage imageWithData:imageData]];
    
    //改变photo所在的view以及显示选择的照片
    if (_selectFileBlock) {
        _selectFileBlock(self.selectFileArray, self.fileNameArray, self.fileSizeArray, self.fileUseNameArray);
    }
}

#pragma mark - KZVideoViewControllerDelegate
- (void)videoViewController:(KZVideoViewController *)videoController didRecordVideo:(KZVideoModel *)videoModel {
    
    NSString *smallVideoPath = videoModel.videoAbsolutePath;
    NSLog(@"urlString----%@", smallVideoPath);
    
    NSError *error = nil;
    NSFileManager *fm = [NSFileManager defaultManager];
    
    
    NSDictionary *attri = [fm attributesOfItemAtPath:smallVideoPath error:&error];
    
    if (self.fileNameArray.count > 0) {
        [self.fileNameArray removeAllObjects];
    }
    if (self.fileSizeArray.count > 0) {
        [self.fileSizeArray removeAllObjects];
    }
    if (self.fileUseNameArray.count > 0) {
        [self.fileUseNameArray removeAllObjects];
    }
    if (self.selectFileArray.count > 0) {
        [self.selectFileArray removeAllObjects];
    }
    
    NSString *originName = [[smallVideoPath componentsSeparatedByString:@"/"] lastObject];
    NSLog(@"attr.fileSize----%f", attri.fileSize/1024.0);
    
    //视频
    [self.fileNameArray addObject:originName];
    [self.fileSizeArray addObject:[NSString stringWithFormat:@"%f",attri.fileSize/1024.0]];
    [self.fileUseNameArray addObject:originName];
    [self.selectFileArray addObject:[NSURL fileURLWithPath:smallVideoPath]];
    
    //封面图片
    //    NSString *coverPhotoName = [self getPhotoName];
    NSString *coverPhotoName = [NSString stringWithFormat:@"%@.JPG", [[originName componentsSeparatedByString:@"."] firstObject]];
    //获取image
    UIImage *coverImage=[UIImage pk_previewImageWithVideoURL:[NSURL fileURLWithPath:smallVideoPath]];
    //压缩图片
    NSData *imageData;
    if (_isCompressImage) {
        imageData = [self compressImage:coverImage];
    } else {
        imageData = UIImagePNGRepresentation(coverImage);
    }
    NSInteger length = [imageData length]/1024; //kb
    
    [self.fileNameArray addObject:coverPhotoName];
    [self.fileSizeArray addObject:[NSString stringWithFormat:@"%ld",(long)length]];
    [self.fileUseNameArray addObject:coverPhotoName];
    [self.selectFileArray addObject:[UIImage imageWithData:imageData]];
    
    //改变photo所在的view以及显示选择的照片
    if (_selectFileBlock) {
        _selectFileBlock(self.selectFileArray, self.fileNameArray, self.fileSizeArray, self.fileUseNameArray);
    }

    
    videoController = nil;
    
    if (_dismissBlock) {
        _dismissBlock(nil);
    }
}

- (void)videoViewControllerDidCancel:(KZVideoViewController *)videoController {
    NSLog(@"没有录到视频");
    videoController = nil;
    
    //改变photo所在的view以及显示选择的照片
    if (_selectFileBlock) {
        _selectFileBlock(self.selectFileArray, self.fileNameArray, self.fileSizeArray, self.fileUseNameArray);
    }

    if (self.dismissBlock) {
        self.dismissBlock(nil);
    }
}

#pragma mark - 录制语音
//语音
- (void)takeVoice:(UIButton *)recordButton {
    _recordBtn = recordButton;
    [recordButton addTarget:self action:@selector(startRecordVoice) forControlEvents:UIControlEventTouchDown];
    [recordButton addTarget:self action:@selector(cancelRecordVoice) forControlEvents:UIControlEventTouchUpOutside];
    [recordButton addTarget:self action:@selector(confirmRecordVoice) forControlEvents:UIControlEventTouchUpInside];
    [recordButton addTarget:self action:@selector(updateCancelRecordVoice) forControlEvents:UIControlEventTouchDragExit];
    [recordButton addTarget:self action:@selector(updateContinueRecordVoice) forControlEvents:UIControlEventTouchDragEnter];
}

#pragma mark - Private Method

/**
 *  开始录音
 */
- (void)startRecordVoice{
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
        [[LGSoundRecorder shareInstance] startSoundRecord:[self getRecordBtnViewController].view recordPath:[self recordPath]];
        //开启定时器
        if (_timerOf60Second) {
            [_timerOf60Second invalidate];
            _timerOf60Second = nil;
        }
        _timerOf60Second = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(sixtyTimeStopAndSendVedio) userInfo:nil repeats:YES];
    } else {
        
    }
}

/**
 *  录音结束
 */
- (void)confirmRecordVoice {
    if ([[LGSoundRecorder shareInstance] soundRecordTime] == 0) {
        [self cancelRecordVoice];
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
    [[LGSoundRecorder shareInstance] stopSoundRecord:[self getRecordBtnViewController].view];
    
    if (_timerOf60Second) {
        [_timerOf60Second invalidate];
        _timerOf60Second = nil;
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
 *  取消录音
 */
- (void)cancelRecordVoice {
    [[LGSoundRecorder shareInstance] soundRecordFailed:[self getRecordBtnViewController].view];
}

/**
 *  录音时间短
 */
- (void)showShotTimeSign {
    [[LGSoundRecorder shareInstance] showShotTimeSign:[self getRecordBtnViewController].view];
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
        [self.recordBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
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
    
    if (self.fileNameArray.count > 0) {
        [self.fileNameArray removeAllObjects];
    }
    if (self.fileSizeArray.count > 0) {
        [self.fileSizeArray removeAllObjects];
    }
    if (self.fileUseNameArray.count > 0) {
        [self.fileUseNameArray removeAllObjects];
    }
    if (self.selectFileArray.count > 0) {
        [self.selectFileArray removeAllObjects];
    }
    
    
    NSTimeInterval seconds = [[LGSoundRecorder shareInstance] soundRecordTime];
    NSString *soundPath = [[LGSoundRecorder shareInstance] soundFilePath];
    NSLog(@"soundPath-----------%@", soundPath);
    NSString *originName = [[soundPath componentsSeparatedByString:@"/"] lastObject];
    float voiceSize = [FileManager fileSizeAtPath:soundPath];
    //语音
    [self.fileNameArray addObject:originName];
    [self.fileSizeArray addObject:[NSString stringWithFormat:@"%f",voiceSize/1024.0]];
    [self.fileUseNameArray addObject:originName];
    [self.selectFileArray addObject:[NSURL URLWithString:soundPath]];
    
    if (_getVoiceSecondBlock) {
        _getVoiceSecondBlock(seconds);
    }
    
    //改变photo所在的view以及显示选择的照片
    if (_selectFileBlock) {
        _selectFileBlock(self.selectFileArray, self.fileNameArray, self.fileSizeArray, self.fileUseNameArray);
    }
}

#pragma mark - LGSoundRecorderDelegate

- (void)showSoundRecordFailed{
    //	[[SoundRecorder shareInstance] soundRecordFailed:self];
    if (_timerOf60Second) {
        [_timerOf60Second invalidate];
        _timerOf60Second = nil;
    }
}

- (void)didStopSoundRecord {
    
}

- (UIViewController *)getRecordBtnViewController {
    for (UIView* next = [self.recordBtn superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

#pragma mark - LGAudioPlayerDelegate
//语音播放
//- (void)audioPlayerStateDidChanged:(LGAudioPlayerState)audioPlayerState forIndex:(NSUInteger)index {
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
//    LGTableViewCell *voiceMessageCell = [_chatTableView cellForRowAtIndexPath:indexPath];
//    LGVoicePlayState voicePlayState;
//    switch (audioPlayerState) {
//        case LGAudioPlayerStateNormal:
//            voicePlayState = LGVoicePlayStateNormal;
//            break;
//        case LGAudioPlayerStatePlaying:
//            voicePlayState = LGVoicePlayStatePlaying;
//            break;
//        case LGAudioPlayerStateCancel:
//            voicePlayState = LGVoicePlayStateCancel;
//            break;
//
//        default:
//            break;
//    }
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [voiceMessageCell setVoicePlayState:voicePlayState];
//    });
//}
//
//#pragma mark - LGTableViewCellDelegate
//
//- (void)voiceMessageTaped:(LGTableViewCell *)cell {
//    [cell setVoicePlayState:LGVoicePlayStatePlaying];
//
//    NSIndexPath *indexPath = [_chatTableView indexPathForCell:cell];
//    LGMessageModel *messageModel = [self.dataArray objectAtIndex:indexPath.row];
//    [[LGAudioPlayer sharePlayer] playAudioWithURLString:messageModel.soundFilePath atIndex:indexPath.row];
//}

#pragma mark - 拍照方法
- (void)takePhoto {
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = sourceType;
    if (self.presentBlock) {
        self.presentBlock(picker);
    }
}

#pragma mark - 从手机相册中选择
- (void)addPhoto {
    WSelectPhotoPickerViewController *pickerVc = [[WSelectPhotoPickerViewController alloc] init];
    //跳转到相册界面
    if (_presentBlock) {
        _presentBlock(pickerVc);
    }
    // 默认显示相册里面的内容SavePhotos
    pickerVc.status = PickerViewShowStatusCameraRoll;
    // 选择图片的最小数，默认是9张图片
    pickerVc.minCount = _selectFileMaxCount - self.selectFileArray.count;
    
    __weak __typeof(self)weakSelf = self;
    pickerVc.callBack = ^(NSArray *assets){
        
        for (WSelectPhotoAssets *ass in assets) {
            //选中的图片大于九张就直接返回
            if (self.selectFileArray.count > 8) {
                break;
            }
            if (_isCompressImage) {
                NSData *data = [self compressImage:ass.originImage];
                [weakSelf.selectFileArray addObject:[UIImage imageWithData:data]];
            } else {
                [weakSelf.selectFileArray addObject:ass.originImage];
            }
            [weakSelf.fileNameArray addObject:ass.fileName];
            [weakSelf.fileSizeArray addObject:[NSString stringWithFormat:@"%f",ass.fileSize]];
            [weakSelf.fileUseNameArray addObject:[self getPhotoName]];
        }

        if (weakSelf.selectFileBlock) {
            weakSelf.selectFileBlock(weakSelf.selectFileArray,weakSelf.fileNameArray,weakSelf.fileSizeArray,weakSelf.fileUseNameArray);
        }
    };
    pickerVc = nil;
}

#pragma mark - 拍照方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    //获取image
    UIImage *selectImage=[info objectForKey:UIImagePickerControllerOriginalImage];
    selectImage = [self fixOrientation:selectImage];
    //压缩图片
    NSData *imageData;
    if (_isCompressImage) {
        imageData = [self compressImage:selectImage];
    } else {
        imageData = UIImagePNGRepresentation(selectImage);
    }
    NSInteger length = [imageData length]/1024; //kb
    
    [self.selectFileArray addObject:[UIImage imageWithData:imageData]];
    [self.fileNameArray addObject:[self getPhotoName]];
    [self.fileUseNameArray addObject:[self getPhotoName]];
    [self.fileSizeArray addObject:[NSString stringWithFormat:@"%ld",(long)length]];
    
    //拍照要先取消UIImagePickerController 再传图片
    if (_dismissBlock) {
        _dismissBlock(nil);
    }
    
    if (_selectFileBlock) {
        _selectFileBlock(self.selectFileArray,self.fileNameArray,self.fileSizeArray,self.fileUseNameArray);
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if (_dismissBlock) {
        _dismissBlock(nil);
    }
}

- (void)presentBlock:(PresentBlock)block {
    if (self.selectFileArray.count > 0) {
        [self.selectFileArray removeAllObjects];
    }
    if (self.fileNameArray.count > 0) {
        [self.fileNameArray removeAllObjects];
    }
    if (self.fileUseNameArray.count > 0) {
        [self.fileUseNameArray removeAllObjects];
    }
    _presentBlock = block;
}

- (void)dismissBlock:(DismissBlock)block {
    _dismissBlock = block;
}

- (void)selectFileBlock:(SelectFileBlock)block {
    _selectFileBlock = block;
}

#pragma mark - 重命名
//以时间戳去命名拍照图片的名字
- (NSString *)getPhotoName {
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970] * 1000;  //  *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%f", a]; //转为字符型
    NSString *phName = [self md5:timeString];
    phName = [NSString stringWithFormat:@"%@.png",phName];
    return phName;
}

- (NSString *)getSightName {
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970] * 1000;  //  *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%f", a]; //转为字符型
    NSString *phName = [self md5:timeString];
    phName = [NSString stringWithFormat:@"%@.mp4",phName];
    return phName;
}

- (NSString *)md5:(NSString *)inPutText {
    const char *cStr = [inPutText UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, strlen(cStr), result);
    
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}

#pragma mark - 旋转90度
- (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

#pragma mark - setMethod
- (void)setSelectFileMaxCount:(NSInteger)selectFileMaxCount {
    _selectFileMaxCount = selectFileMaxCount;
}

- (void)setIsKeepLastImage:(BOOL)isKeepLastImage {
    _isKeepLastImage = isKeepLastImage;
}

- (void)setIsCompressImage:(BOOL)isCompressImage {
    _isCompressImage = isCompressImage;
}

- (void)setShowFlatAlertView:(BOOL)showFlatAlertView {
    _showFlatAlertView = showFlatAlertView;
}

- (void)setHaveSmallVideo:(BOOL)haveSmallVideo {
    _haveSmallVideo = haveSmallVideo;
}

#pragma mark - 压缩图片
- (NSData *)compressImage:(UIImage *)image {
    NSUInteger maxFileSize = FILE_MAXSIZE;
    NSData *originImageData = UIImagePNGRepresentation(image);
    NSInteger length = [originImageData length]/1024;
    if (length < maxFileSize) {
        return originImageData;
    } else {
        CGFloat compressionRatio = 0.7f;
        CGFloat maxCompressionRatio = 0.1f;
        NSData *imageData = UIImageJPEGRepresentation(image, compressionRatio);
        
        while (imageData.length > maxFileSize && compressionRatio > maxCompressionRatio) {
            compressionRatio -= 0.1f;
            imageData = UIImageJPEGRepresentation(image, compressionRatio);
        }
        return imageData;
    }
}

#pragma mark - MOV 转MP4
- (NSString *)movFileTransformToMP4WithSourceUrl:(NSURL *)sourceUrl {
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:sourceUrl options:nil];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    NSString *exportPath;
    
    if ([compatiblePresets containsObject:AVAssetExportPresetLowQuality]) {
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]initWithAsset:avAsset presetName:AVAssetExportPresetPassthrough];
        exportPath = [NSString stringWithFormat:@"%@/%@.mp4",
                      [NSHomeDirectory() stringByAppendingString:@"/tmp"],
                      @"1"];
        exportSession.outputURL = [NSURL fileURLWithPath:exportPath];
        NSLog(@"%@", exportPath);
        exportSession.outputFileType = AVFileTypeMPEG4;
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            switch ([exportSession status]) {
                case AVAssetExportSessionStatusFailed:
                    NSLog(@"Export failed: %@", [[exportSession error] localizedDescription]);
                    break;
                case AVAssetExportSessionStatusCancelled:
                    NSLog(@"Export canceled");
                    break;
                case AVAssetExportSessionStatusCompleted:
                    NSLog(@"转换成功");
                    break;
                default:
                    break;
            }
        }];
    }
    return exportPath;
}

#pragma mark - dealloc
- (void)dealloc {
    _showFlatAlertView = NO;
    _haveSmallVideo = NO;
    _selectFileMaxCount = 0;
    [[PKPlayerManager sharedManager] removeAllPlayer];
}



@end
