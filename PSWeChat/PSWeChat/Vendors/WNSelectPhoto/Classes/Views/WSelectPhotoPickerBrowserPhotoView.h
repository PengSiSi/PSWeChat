//
//  WSelectPhotoPickerBrowserPhotoView.h
//  WNSelectPhoto
//
//  Created by 王楠 on 15/5/21.
//  Copyright (c) 2015年 王楠. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@protocol WPhotoPickerBrowserPhotoViewDelegate;

@interface WSelectPhotoPickerBrowserPhotoView : UIView {}

@property (nonatomic, weak) id <WPhotoPickerBrowserPhotoViewDelegate> tapDelegate;

@end

@protocol WPhotoPickerBrowserPhotoViewDelegate <NSObject>

@optional

- (void)view:(UIView *)view singleTapDetected:(UITouch *)touch;
- (void)view:(UIView *)view doubleTapDetected:(UITouch *)touch;

@end
