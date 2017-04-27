//
//  AddTextAndPhotoView.h
//  PSWeChat
//
//  Created by 思 彭 on 2017/4/19.
//  Copyright © 2017年 思 彭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddTextAndPhotoView : UIView

@property (nonatomic, strong) NSArray *passImageArray; // 事先选好的图片
@property (nonatomic, copy) void(^selectedImageBlock)(NSMutableArray *imageArray,NSMutableArray *fileNameArray,NSMutableArray *sizeArray,NSMutableArray *userNameArray);/**选择的图片信息回调 */

@end
