//
//  WSelectPhotoAssets.h
//  WNSelectPhoto
//
//  Created by 王楠 on 15/5/20.
//  Copyright (c) 2015年 王楠. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
@interface WSelectPhotoAssets : NSObject
@property (strong,nonatomic) ALAsset *asset;
/**
 *  缩略图
 */
- (UIImage *)thumbImage;
/**
 *  原图
 */
- (UIImage *)originImage;
/**
 *  图片名称
 */
- (NSString *)fileName;
/**
 *  图片大小    以kB为单位
 */
- (float)fileSize;
/**
 *  获取是否是视频类型, Default = false
 */
@property (assign,nonatomic) BOOL isVideoType;

@end
