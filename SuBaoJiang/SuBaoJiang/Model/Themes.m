//
//  Themes.m
//  SuBaoJiang
//
//  Created by apple on 15/6/5.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "Themes.h"

@implementation Themes

- (instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        _th_id = [[dic objectForKey:@"th_id"] intValue] ;
        _th_content = [dic objectForKey:@"th_content"] ;
        _th_img = [dic objectForKey:@"th_img"] ;
        _th_href = [dic objectForKey:@"th_href"] ;
        
        _themeCate = [[dic objectForKey:@"th_category"] intValue] ;
        _t_id = [[dic objectForKey:@"t_id"] intValue] ;
        _begin_time = [[dic objectForKey:@"begin_time"] longLongValue] ;
        _end_time = [[dic objectForKey:@"end_time"] longLongValue] ;
    }
    return self;
}

@end
