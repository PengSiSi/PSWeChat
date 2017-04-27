//
//  WSelectPhotoCommon.h
//  WNSelectPhoto
//
//  Created by 王楠 on 15/5/20.
//  Copyright (c) 2015年 王楠. All rights reserved.
//

#ifndef WNSelectPhoto_WSelectPhotoCommon_h
#define WNSelectPhoto_WSelectPhotoCommon_h

// 图片最多显示9张，超过9张取消单击事件
static NSInteger const KPhotoShowMaxCount = 9;

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

// Navigation Color
//  橙色: FF8000  白色: FFFFFF
//导航条颜色 默认-0x2f3535
#define DefaultNavbarTintColor kNavBarBgColor
//左右按钮颜色  默认-0xd5d5d5
#define DefaultNavTintColor UIColorFromRGB(0xFFFFFF)
//标题颜色  默认-0xd5d5d5
#define DefaultNavTitleColor UIColorFromRGB(0xFFFFFF)

// 标记小圆圈颜色
#define circleColor [UIColor orangeColor]

#define iOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)

// NSNotification
static NSString *PICKER_TAKE_DONE = @"PICKER_TAKE_DONE";

// 图片路径
#define WSelectPhotoSrcName(file) [@"WSelectPhoto.bundle" stringByAppendingPathComponent:file]

#endif
