//
//  JsonDataService.h
//  PSWeChat
//
//  Created by 思 彭 on 2017/4/24.
//  Copyright © 2017年 思 彭. All rights reserved.

// 读取json,plist文件工具

#import <Foundation/Foundation.h>

@interface JsonDataService : NSObject

+ (JsonDataService *)shareInstance;

/**
 返回json文件数据

 @param jsonName json文件名
 @param type json类型,这里是json
 @return 返回json文件数据
 */
- (id)readJsonDataWithPath: (NSString *)jsonName jsonType: (NSString *)type;


/**
 返回plist文件数据

 @param plistPath plist文件名
 @param type plist类型,这里是plist
 @return 返回plist文件数据
 */
- (id)readPlistDataWithPath: (NSString *)plistPath jsonType: (NSString *)type;

@end
