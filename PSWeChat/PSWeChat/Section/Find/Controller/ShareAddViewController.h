//
//  ShareAddViewController.h
//  PSWeChat
//
//  Created by 思 彭 on 2017/4/19.
//  Copyright © 2017年 思 彭. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger, ShareType) {
    SharePhotoType = 0, //图像
    ShareSightType = 1, //小视频
    ShareVoiceType //语音
};

@interface ShareAddViewController : BaseViewController

@property (assign, nonatomic) ShareType shareType;/**< 视频、图片还是语音的样式*/
@property (strong, nonatomic) NSDictionary *passImageDict;/**< 传递过去的图片数组*/

@property (copy, nonatomic) void(^addShareSuccess)();/**<分享发布成功的回调 */

@end
