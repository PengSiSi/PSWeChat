//
//  JsonDataService.m
//  PSWeChat
//
//  Created by 思 彭 on 2017/4/24.
//  Copyright © 2017年 思 彭. All rights reserved.
//

#import "JsonDataService.h"

static JsonDataService *shareInstance = nil;

@implementation JsonDataService

+ (JsonDataService *)shareInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[self alloc]init];
    });
    return shareInstance;
}

- (id)readJsonDataWithPath: (NSString *)jsonName jsonType: (NSString *)type {
    
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:jsonName ofType:type];
    NSData *data = [NSData dataWithContentsOfFile:jsonPath];
    NSError *error;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data
                                                  options:NSJSONReadingAllowFragments
                                                    error:&error];
    if (error != nil) {
        NSLog(@"读取数据失败...");
        return 0;
    }
    return jsonObject;
}

- (id)readPlistDataWithPath: (NSString *)plistPath jsonType: (NSString *)type {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:plistPath ofType:type];
    NSArray *dataArray = [[NSArray alloc]initWithContentsOfFile:path];
    return dataArray;
}

@end
