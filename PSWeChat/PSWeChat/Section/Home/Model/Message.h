//
//  Message.h
//  PSWeChat
//
//  Created by 思 彭 on 2017/4/26.
//  Copyright © 2017年 思 彭. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Message : NSObject

@property (nonatomic) float height;
@property (nullable, nonatomic, retain) NSString *message;
@property (nonatomic) int16_t messageType;
@property (nonatomic) int64_t sender;
@property (nonatomic) NSTimeInterval sendTime;
@property (nonatomic, assign) BOOL showSendTime;

@end
