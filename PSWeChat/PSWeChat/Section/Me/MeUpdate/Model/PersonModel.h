//
//  PersonModel.h
//  PSWeChat
//
//  Created by 思 彭 on 2017/4/16.
//  Copyright © 2017年 思 彭. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonModel : NSObject

@property (nonatomic, copy) NSString *avater; /**<头像 */
@property (nonatomic, copy) NSString *name; /**<用户名称 */
@property (nonatomic, copy) NSString *weChatId; /**<微信号 */

@end
