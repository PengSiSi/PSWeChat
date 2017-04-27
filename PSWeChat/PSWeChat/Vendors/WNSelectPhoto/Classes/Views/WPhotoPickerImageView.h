//
//  WPhotoPickerImageView.h
//  WNSelectPhoto
//
//  Created by 王楠 on 15/5/20.
//  Copyright (c) 2015年 王楠. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPhotoPickerImageView : UIImageView
/**
 *  是否有蒙版层
 */
@property (nonatomic , assign , getter=isMaskViewFlag) BOOL maskViewFlag;
/**
 *  是否有右上角打钩的按钮
 */
@property (nonatomic , assign) BOOL animationRightTick;
/**
 *  是否视频类型
 */
@property (assign,nonatomic) BOOL isVideoType;

@end
