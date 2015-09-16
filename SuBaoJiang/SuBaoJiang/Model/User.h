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

- (instancetype)initWithDic:(NSDictionary *)dic ;

@end
