//
//  SelectFileManager.h
//  Donghuamen
//
//  Created by AlicePan on 17/3/7.
//  Copyright © 2017年 Combanc. All rights reserved.
//  选择文件方法类（可以从相册中选择图片、拍照、录制小视频、录制语音）

#import <Foundation/Foundation.h>

typedef void(^PresentBlock)(id viewController);
typedef void(^DismissBlock)(id dismissVC);
typedef void(^SelectFileBlock)(NSMutableArray *fileArray, NSMutableArray *nameArray, NSMutableArray *sizeArray, NSMutableArray *userNameArray);

@interface SelectFileManager : NSObject

//private
@property (copy, nonatomic) PresentBlock presentBlock;/**<界面跳转 */
@property (copy, nonatomic) DismissBlock dismissBlock;/**<界面跳转 */
@property (copy, nonatomic) SelectFileBlock selectFileBlock;/**<选中的图片 */

//public
@property (assign, nonatomic) NSInteger selectFileMaxCount;/**< 可以选择最多的照片个数, 默认9张*/
@property (assign, nonatomic) BOOL isKeepLastImage;/**< 是否保留上次的图片 默认是no*/
@property (assign, nonatomic) BOOL isCompressImage;/**< 是否在选择完图片或拍完照之后就压缩图片 默认是NO不压缩*/
@property (assign, nonatomic) BOOL showFlatAlertView;/**< 是否显示扁平的alertView 默认是no*/
@property (assign, nonatomic) BOOL haveSmallVideo;/**< 是否要选小视频， 默认是no*/

@property (copy, nonatomic) void(^getVoiceSecondBlock) (NSTimeInterval interval);/**< 获取语音时间回调*/

+ (SelectFileManager *)sharedInstance;

//跳转页面回调
- (void)presentBlock:(PresentBlock)block;
//返回页面回调 拍照必须调用此方法
- (void)dismissBlock:(DismissBlock)block;
//选择的图片信息回调
- (void)selectFileBlock:(SelectFileBlock)block;

- (NSData *)compressImage:(UIImage *)image;

//弹窗操作
- (void)selectPhotoAction;
//拍摄小视频
- (void)takeSight;
//选择照片
- (void)addPhoto;
//拍照
- (void)takePhoto;
//语音
- (void)takeVoice:(UIButton *)recordButton;

- (NSString *)getSightName;
- (NSString *)getPhotoName;
- (UIImage *)fixOrientation:(UIImage *)aImage;

@end
