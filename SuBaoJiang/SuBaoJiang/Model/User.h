//
//  User.h
//  SuBaoJiang
//
//  Created by apple on 15/6/5.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic)           int             u_id ;
@property (nonatomic,copy)      NSString        *u_headpic ;
@property (nonatomic,copy)      NSString        *u_nickname ;
@property (nonatomic,copy)      NSString        *u_description ;
@property (nonatomic)           int             gender ; // 0-无,1-男,2-女

- (instancetype)initWithDic:(NSDictionary *)dic ;
- (BOOL)isCurrentUserBeOwner ;
- (NSString *)getUserSex ;
- (NSString *)getUserSexImageString ;
@end
