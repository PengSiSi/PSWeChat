//
//  WSelectPhotoPickerDatas.h
//  WNSelectPhoto
//
//  Created by 王楠 on 15/5/20.
//  Copyright (c) 2015年 王楠. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class WSelectPhotoPickerGroup;

// 回调
typedef void(^callBackBlock)(id obj);

@interface WSelectPhotoPickerDatas : NSObject

/**
 *  获取所有组
 */
+ (instancetype) defaultPicker;

/**
 * 获取所有组对应的图片
 */
- (void) getAllGroupWithPhotos : (callBackBlock ) callBack;

/**
 * 获取所有组对应的Videos
 */
- (void) getAllGroupWithVideos : (callBackBlock ) callBack;

/**
 *  传入一个组获取组里面的Asset
 */
- (void) getGroupPhotosWithGroup : (WSelectPhotoPickerGroup *) pickerGroup finished : (callBackBlock ) callBack;

/**
 *  传入一个AssetsURL来获取UIImage
 */
- (void) getAssetsPhotoWithURLs:(NSURL *) url callBack:(callBackBlock ) callBack;
@end
