//
//  WSelectPhoto.h
//  WNSelectPhoto
//
//  Created by 王楠 on 15/5/20.
//  Copyright (c) 2015年 王楠. All rights reserved.
//

#ifndef WNSelectPhoto_WSelectPhoto_h
#define WNSelectPhoto_WSelectPhoto_h

#import "WSelectPhotoPickerViewController.h"
#import "WSelectPhotoAssets.h"

/**
 *
 
 // 使用方法
 // 引入 #import "WSelectPhoto.h"
 
 //保存选中图片的数组
 NSMutableArray *mutArr = [NSMutableArray arrayWithCapacity:10];
 
 WSelectPhotoPickerViewController *pickerVc = [[WSelectPhotoPickerViewController alloc] init];
 // 默认显示相册里面的内容SavePhotos
 pickerVc.status = PickerViewShowStatusCameraRoll;
 // 选择图片的最小数，默认是9张图片
 pickerVc.minCount = 9;
 // 设置代理回调
 //pickerVc.delegate = self;
 // 展示控制器
 [pickerVc show];
 //如果不能跳转的话，加下面一句
 [self presentViewController:pickerVc animated:YES completion:nil];

 //代理回调方法：
 - (void)pickerViewControllerDoneAsstes:(NSArray *)assets{
        //拿到选中图片
        for (WSelectPhotoAssets *ass in assets) {
            [mutArr addObject:ass.originImage];
        }
            NSLog(@"mutArr:%@",mutArr);
 }
 
 //或block回调方法
 pickerVc.callBack = ^(NSArray *assets){
    // TODO 回调结果，可以不用实现代理
    //拿到选中图片
    for (WSelectPhotoAssets *ass in assets) {
        [mutArr addObject:ass.originImage];
    }
        NSLog(@"mutArr:%@",mutArr);

 };
 
 */

#endif
