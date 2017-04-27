//
//  MediaModel.h
//  PSWeChat
//
//  Created by 思 彭 on 2017/4/16.
//  Copyright © 2017年 思 彭. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MediaModel : NSObject

//语音
@property (copy, nonatomic) NSString *voicePath;/**< 语音路径*/
@property (assign, nonatomic) NSInteger voiceSeconds;/**< 语音时间*/

//小视频
@property (copy, nonatomic) NSString *sightPath;/**< 视频路径*/
@property (copy, nonatomic) NSString *coverImagePath;/**< 封面图片路径*/
@property (strong, nonatomic) UIImage *coverImage;/**< 封面图片Image*/

//图片
@property (copy, nonatomic) NSString *imagePath;/**< 图片路径*/
@property (copy, nonatomic) NSString *highQualityImagePath;/**< 高质量图片路径*/
@property (strong, nonatomic) UIImage *image;/**< 图片Image*/

@end
