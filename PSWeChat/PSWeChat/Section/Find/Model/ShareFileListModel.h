//
//  ShareFileListModel.h
//  PSWeChat
//
//  Created by 思 彭 on 2017/4/19.
//  Copyright © 2017年 思 彭. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareFileListModel : NSObject

@property (copy, nonatomic) NSString *fileUseName;/**<附件使用名 */
@property (copy, nonatomic) NSString *fileName;/**<附件名称 */
@property (copy, nonatomic) NSString *smallImageUrl;/**<小图图片地址 */
@property (copy, nonatomic) NSString *filePath;/**<附件,图片路径 */
@property (copy, nonatomic) NSString *isVideo;/**< s*/

@end
