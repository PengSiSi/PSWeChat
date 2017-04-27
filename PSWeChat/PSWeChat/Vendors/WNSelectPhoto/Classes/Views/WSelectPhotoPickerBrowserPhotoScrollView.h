//
//  WSelectPhotoPickerBrowserPhotoScrollView.h
//  WNSelectPhoto
//
//  Created by 王楠 on 15/5/21.
//  Copyright (c) 2015年 王楠. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "WSelectPhotoPickerBrowserPhotoImageView.h"
#import "WSelectPhotoPickerBrowserPhotoView.h"
#import "WSelectPhotoPickerBrowserPhoto.h"
#import "WSelectPhoto.h"

typedef void(^callBackBlock)(id obj);
@class WSelectPhotoPickerBrowserPhotoScrollView;

@protocol WPhotoPickerPhotoScrollViewDelegate <NSObject>
@optional
// 单击调用
- (void) pickerPhotoScrollViewDidSingleClick:(WSelectPhotoPickerBrowserPhotoScrollView *)photoScrollView;
@end

@interface WSelectPhotoPickerBrowserPhotoScrollView : UIScrollView <UIScrollViewDelegate, WPhotoPickerBrowserPhotoImageViewDelegate,WPhotoPickerBrowserPhotoViewDelegate>

@property (nonatomic,strong) WSelectPhotoAssets *photo;
@property (nonatomic, weak) id <WPhotoPickerPhotoScrollViewDelegate> photoScrollViewDelegate;
// 长按图片的操作，可以外面传入
@property (strong,nonatomic) UIActionSheet *sheet;
// 单击销毁的block
@property (copy,nonatomic) callBackBlock callback;


@end
