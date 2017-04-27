//
//  SelectPhotoView.h
//  QianfengSchool
//
//  Created by chenhuan on 16/7/20.
//  Copyright © 2016年 Combanc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectPhotoView : UIView

@property (assign, nonatomic) BOOL isCompressImage;/**< 是否在选择图片之后或拍照之后就压缩图片 默认是NO*/
@property (assign, nonatomic) BOOL *showFlatAlertView;/**< 是否显示扁平的alertView 默认是no*/


@property (nonatomic, copy) void(^presentBlock)(id presentVC);/**跳转页面回调 */
@property (nonatomic, copy) void(^dismissBlock)(id dismissVC);/**返回页面回调 */
@property (nonatomic, copy) void(^selectImageBlock)(NSMutableArray *imageArray,NSMutableArray *fileNameArray,NSMutableArray *sizeArray,NSMutableArray *userNameArray);/**选择的图片信息回调 */

/**
 *  重写构造方法
 *
 *  @param size        图片的大小，默认最小间距和最大间距均为5
 *  @param imageArray  点击添加图片的图片数组
 *  @param count       可以选择图片的最大数量
 *  @param array       你需要显示的图片数组
 *  @param spaceOfLine Item间隔
 *  @return self
 */
- (instancetype)initWithItemSize:(CGSize)size
                placeholderImage:(NSMutableArray *)imageArray
             selectPhotoMaxCount:(NSInteger)count
                  passImageArray:(NSMutableArray *)array
                     spaceOfline:(NSInteger)spaceOfLine;
@end
