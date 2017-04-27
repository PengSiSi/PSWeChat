//
//  AreaModel.h
//  PSWeChat
//
//  Created by 思 彭 on 2017/4/24.
//  Copyright © 2017年 思 彭. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface cityModel : NSObject

@property (nonatomic, copy) NSString *city;
@property (nonatomic, strong) NSArray *areas;

@end

@interface AreaListModel : NSObject

@property (nonatomic, copy) NSString *state;
@property (nonatomic, strong) NSArray <cityModel *> *cities;

@end
