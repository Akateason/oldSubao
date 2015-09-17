//
//  User.m
//  SuBaoJiang
//
//  Created by apple on 15/6/5.
//  Copyright (c) 2015年 teason. All rights reserved.
//
#import "DigitInformation.h"
#import "User.h"
#import "CommonFunc.h"

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

- (BOOL)isCurrentUserBeOwner
{
    if (self.u_id != 0 && self.u_id == G_USER.u_id)
    {
        return YES ;
    }
    
    return NO ;
}

- (NSString *)getUserSex
{
    return [CommonFunc boyGirlNum2Str:self.gender] ;
}

- (NSString *)getUserSexImageString
{
    NSString *result = @"" ;
    if (!self.gender) return nil ;
    
    switch (self.gender)
    {
        case 1:
            result = @"u_male" ;
            break;
        case 2:
            result = @"u_female" ;
            break;
        default:
            break;
    }

    return result ;
}

@end
