//
//  SelectPhotoCollectionViewCell.h
//  Donghuamen
//
//  Created by AlicePan on 16/11/24.
//  Copyright © 2016年 Combanc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectPhotoCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageV;/**<视图 */
@property (nonatomic, strong) UIButton *deleteImgBtn;/**<点击删除图片按钮 */

@property (copy, nonatomic) void(^deleteImageBtnClick) (UIButton *button);/**< <#tip#>*/


@end
