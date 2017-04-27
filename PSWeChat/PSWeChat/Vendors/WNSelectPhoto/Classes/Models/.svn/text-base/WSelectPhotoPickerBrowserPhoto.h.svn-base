//
//  WSelectPhotoPickerBrowserPhoto.h
//  WNSelectPhoto
//
//  Created by 王楠 on 15/5/20.
//  Copyright (c) 2015年 王楠. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "WSelectPhotoAssets.h"
@interface WSelectPhotoPickerBrowserPhoto : NSObject
/**
 *  自动适配是不是以下几种数据
 */
@property (nonatomic , strong) id photoObj;
/**
 *  保存相册模型
 */
@property (nonatomic , strong) WSelectPhotoAssets *asset;
/**
 *  URL地址
 */
@property (nonatomic , strong) NSURL *photoURL;
/**
 *  原图
 */
@property (nonatomic , strong) UIImage *photoImage;
/**
 *  缩略图
 */
@property (nonatomic , strong) UIImage *thumbImage;
/**
 *  传入一个图片对象，可以是URL/UIImage/NSString，返回一个实例
 */
+ (instancetype)photoAnyImageObjWith:(id)imageObj;

@end
