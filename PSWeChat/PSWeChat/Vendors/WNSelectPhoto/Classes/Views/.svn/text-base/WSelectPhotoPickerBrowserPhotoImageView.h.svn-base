//
//  WSelectPhotoPickerBrowserPhotoImageView.h
//  WNSelectPhoto
//
//  Created by 王楠 on 15/5/20.
//  Copyright (c) 2015年 王楠. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@protocol WPhotoPickerBrowserPhotoImageViewDelegate;

@interface WSelectPhotoPickerBrowserPhotoImageView : UIImageView {}

@property (nonatomic, weak) id <WPhotoPickerBrowserPhotoImageViewDelegate> tapDelegate;
@property (assign,nonatomic) CGFloat progress;

@end

@protocol WPhotoPickerBrowserPhotoImageViewDelegate <NSObject>

@optional

- (void)imageView:(UIImageView *)imageView singleTapDetected:(UITouch *)touch;
- (void)imageView:(UIImageView *)imageView doubleTapDetected:(UITouch *)touch;
@end
