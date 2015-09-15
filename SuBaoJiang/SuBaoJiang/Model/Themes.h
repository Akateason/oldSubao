//
//  Themes.h
//  SuBaoJiang
//
//  Created by apple on 15/6/5.
//  Copyright (c) 2015年 teason. All rights reserved.
//


#import "PublicEnum.h"
#import <Foundation/Foundation.h>

// 首页主题
@interface Themes : NSObject

@property (nonatomic)           int                 th_id ;
@property (nonatomic)           MODE_skipCategory   themeCate ;
@property (nonatomic,copy)      NSString            *th_content ;
@property (nonatomic,copy)      NSString            *th_img ;
@property (nonatomic,copy)      NSString            *th_href ;
@property (nonatomic)           int                 t_id ; // topic id , if has
@property (nonatomic)           long long           begin_time ;
@property (nonatomic)           long long           end_time ;

- (instancetype)initWithDic:(NSDictionary *)dic ;

@end
