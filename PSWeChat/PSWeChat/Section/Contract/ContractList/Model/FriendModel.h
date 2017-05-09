//
//  FriendModel.h
//  PSWeChat
//
//  Created by 思 彭 on 2017/4/17.
//  Copyright © 2017年 思 彭. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FriendModel : NSObject

@property(nonatomic,copy) NSString *photo;
@property(nonatomic,copy) NSString *userName;
@property(nonatomic,copy) NSString *userId;
@property(nonatomic,copy) NSString *phoneNO;
@property (copy, nonatomic) NSString *firstLetter; // 首字母

/**
 选择联系人模块需要多选使用
 */
@property (nonatomic, assign) BOOL isSelected;

@end
