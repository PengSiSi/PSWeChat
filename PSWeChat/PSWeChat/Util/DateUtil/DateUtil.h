//
//  DateUtil.h
//  PSWeChat
//
//  Created by 思 彭 on 2017/4/26.
//  Copyright © 2017年 思 彭. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateUtil : NSObject

+ (NSDateFormatter*)sharedDateFormatter;

/*字符串转NSDate*/
+ (NSDate*)stringToDate:(NSString*)dateString format:(NSString*)format;
/*NSDate转字符串*/
+ (NSString*)dateString:(NSDate*)date withFormat:(NSString*)format;
/*获取当前的时间标识*/
+ (NSString*)dateIdentifierNow;
/*从某个格式的时间字符串转到另一个格式的时间字符串*/
+ (NSString*)dateString:(NSString*)originalStr
             fromFormat:(NSString*)fromFormat
               toFormat:(NSString*)toFormat;
/*获取尽量短的本地化时间字符串*/
+ (NSString*)localizedShortDateString:(NSDate*)date;
+ (NSString*)localizedShortDateStringFromInterval:(NSTimeInterval)interval;

@end
