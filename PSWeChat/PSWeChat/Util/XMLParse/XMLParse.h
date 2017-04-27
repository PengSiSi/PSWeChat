//
//  XMLParse.h
//  QianfengSchool
//
//  Created by AlicePan on 16/9/18.
//  Copyright © 2016年 Combanc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMLParse : NSObject

/*
 返回数据XML解析类
 */
+ (NSString *)getSimpleResult:(NSData *)data;

@end
