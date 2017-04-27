//
//  AreaModel.m
//  PSWeChat
//
//  Created by 思 彭 on 2017/4/24.
//  Copyright © 2017年 思 彭. All rights reserved.
//

#import "AreaListModel.h"

@implementation cityModel : NSObject

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"areas" : @"AreaModel"
             };
}

@end

@implementation AreaListModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"cities" : @"cityModel"
             };
}

@end
