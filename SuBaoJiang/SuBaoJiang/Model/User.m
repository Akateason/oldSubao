//
//  User.m
//  SuBaoJiang
//
//  Created by apple on 15/6/5.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "User.h"

@implementation User

- (instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        _u_id = [[dic objectForKey:@"u_id"] intValue] ;
        
        if (![[dic objectForKey:@"u_nickname"] isKindOfClass:[NSNull class]]) {
            _u_nickname = [dic objectForKey:@"u_nickname"] ;
        }
        
        if (![[dic objectForKey:@"u_headpic"] isKindOfClass:[NSNull class]]) {
            _u_headpic = [dic objectForKey:@"u_headpic"] ;
        }
        
        if (![[dic objectForKey:@"u_description"] isKindOfClass:[NSNull class]]) {
            _u_description = [dic objectForKey:@"u_description"] ;
        }
        
    }
    return self;
}



@end
