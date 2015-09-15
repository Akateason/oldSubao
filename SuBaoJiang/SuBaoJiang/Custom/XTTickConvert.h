//
//  MyTick.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-10-29.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//


#define TIME_STR_FORMAT_1       @"yyyy 年 MM 月 dd 日"
#define TIME_STR_FORMAT_2       @"yyyy年MM月dd日"
#define TIME_STR_FORMAT_3       @"YYYY-MM-dd HH:mm:ss"
#define TIME_STR_FORMAT_4       @"YYYYMMddHHmmss"
#define TIME_STR_FORMAT_5       @"YYYY-MM-dd"
#define TIME_STR_FORMAT_6       @"YYYY-MM-dd HH:mm"
#define TIME_STR_FORMAT_7       @"MM-dd"
#define TIME_STR_FORMAT_8       @"MM-dd HH:mm"

#import <Foundation/Foundation.h>

@interface XTTickConvert : NSObject

#pragma mark --
//转tick
+ (long long)getTickWithDate:(NSDate *)_date;
//转tick,转出string
+ (NSString *)getDateWithTick:(long long)_tick AndWithFormart:(NSString *)formatStr;
//转tick,转出NsDate
+ (NSDate *)getNSDateWithTick:(long long)_tick;
//转str变NSdate
+ (NSDate *)getNSDateWithDateStr:(NSString *)dateStr AndWithFormat:(NSString *)format;
//转nsdate变str
+ (NSString *)getStrWithNSDate:(NSDate *)date AndWithFormat:(NSString *)format;

#pragma mark --
//x分钟前/x小时前/昨天/x天前/x个月前/x年前
+ (NSString *)timeInfoWithDate:(NSDate *)date ;
+ (NSString *)getMMDDWithDate:(NSDate *)date ;

@end
