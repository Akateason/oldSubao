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
        
        if (![[dic objectForKey:@"u_gender"] isKindOfClass:[NSNull class]]) {
            _gender = [[dic objectForKey:@"u_gender"] intValue];
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
    //u_femaie
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


//  manually setting KVO value Changed . 
+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)theKey
{
    BOOL automatic = NO ;
    if ([theKey isEqualToString:@"u_headpic"] || [theKey isEqualToString:@"u_nickname"] || [theKey isEqualToString:@"u_description"] || [theKey isEqualToString:@"gender"])
    {
        automatic = NO ;
    }
    else
    {
        automatic = [super automaticallyNotifiesObserversForKey:theKey] ;
    }
    return automatic ;
}

- (void)setU_headpic:(NSString *)u_headpic
{
    if (![u_headpic isEqualToString:_u_headpic]) {
        [self willChangeValueForKey:@"u_headpic"];
        _u_headpic = u_headpic ;
        [self didChangeValueForKey:@"u_headpic"];
    }
}

- (void)setU_nickname:(NSString *)u_nickname
{
    if (![u_nickname isEqualToString:_u_nickname]) {
        [self willChangeValueForKey:@"u_nickname"];
        _u_nickname = u_nickname ;
        [self didChangeValueForKey:@"u_nickname"];
    }
}

- (void)setU_description:(NSString *)u_description
{
    if (![u_description isEqualToString:_u_description]) {
        [self willChangeValueForKey:@"u_description"];
        _u_description = u_description ;
        [self didChangeValueForKey:@"u_description"];
    }
}

- (void)setGender:(int)gender
{
    if (gender != _gender) {
        [self willChangeValueForKey:@"gender"];
        _gender = gender ;
        [self didChangeValueForKey:@"gender"];
    }
}

@end


