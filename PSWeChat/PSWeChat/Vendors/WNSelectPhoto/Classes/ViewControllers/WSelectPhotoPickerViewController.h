//
//  WSelectPhotoPickerViewController.h
//  WNSelectPhoto
//
//  Created by 王楠 on 15/5/21.
//  Copyright (c) 2015年 王楠. All rights reserved.
//

#import <UIKit/UIKit.h>

// 回调
typedef void(^callBackBlock)(id obj);

// 状态组
typedef NS_ENUM(NSInteger , PickerViewShowStatus) {
    PickerViewShowStatusGroup = 0, // default groups .
    PickerViewShowStatusCameraRoll ,
    PickerViewShowStatusSavePhotos ,
    PickerViewShowStatusPhotoStream ,
    PickerViewShowStatusVideo,
};

@protocol WPhotoPickerViewControllerDelegate <NSObject>
/**
 *  返回所有的Asstes对象
 */
- (void) pickerViewControllerDoneAsstes : (NSArray *) assets;
@end

@interface WSelectPhotoPickerViewController : UIViewController

// @optional
@property (nonatomic , weak) id<WPhotoPickerViewControllerDelegate> delegate;
// 决定你是否需要push到内容控制器, 默认显示组
@property (nonatomic , assign) PickerViewShowStatus status;
// 可以用代理来返回值或者用block来返回值
@property (nonatomic , copy) callBackBlock callBack;
// 每次选择图片的最小数, 默认与最大数是9
@property (nonatomic , assign) NSInteger minCount;
// 记录选中的值
@property (strong,nonatomic) NSArray *selectPickers;

// @function
// 展示控制器
- (void)show;

/**
 *  传入一个图片对象（ALAsset、URL）
 *
 *  @return 返回图片
 */
+ (UIImage *) getImageWithImageObj:(id)imageObj;
@end
