
//
//  Macros_Color.h
//  baiduMap
//
//  Created by Mike on 16/3/29.
//  Copyright © 2016年 Mike. All rights reserved.
//

#ifndef Macros_Color_h
#define Macros_Color_h

// Method Macro
#define ColorRGB(r, g, b) ([UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f])

#define ColorRGBA(r, g, b, a) ([UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)])

// Constants
// 主色调：绿色

/// 绿色
#define GREEN_COLOR ColorRGBA(30, 180, 20, 1)
/// 蓝色
#define BLUE_COLOR HEXCOLOR(0x00aaff)
// RGBA(76, 135, 240, 1)

/// 紫色
#define PURPLE_COLOR ColorRGBA(118, 87, 165, 1)
/// 红色
#define RED_COLOR ColorRGBA(246, 63, 111, 1)
/// 青色
#define CYAN_COLOR ColorRGBA(35, 199, 191, 1)
/// 橙色
#define ORANGE_COLOR ColorRGBA(253, 122, 8, 1)

//蓝
#define F_BLUE ColorRGBA(57, 116, 191, 1)

// 导航栏背景颜色

#define kNavBarBgColor ColorRGBA(54, 53, 58, 1)

// 联系人搜索的颜色 绿色
#define kThemeColor [UIColor colorWithRed:0 green:(190 / 255.0) blue:(12 / 255.0) alpha:1]

//textField、textView的placeholder颜色
#define PLACEHOLDER_COLOR ColorRGBA(199, 199, 205, 1)

//文字颜色
#define TEXT_COLOR_GRAY [UIColor grayColor]

#endif /* Macros_Color_h */
