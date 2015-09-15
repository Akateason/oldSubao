//
//  DigitInformation.h
//  ParkingSys
//
//  Created by mini1 on 14-4-2.
//  Copyright (c) 2014年 mini1. All rights reserved.
//

#define FLOAT_HUD_MINSHOW       2.0f


#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "User.h"

#define G_TOKEN                     [DigitInformation shareInstance].g_token

#define DB                          [DigitInformation shareInstance].db

#define G_BOOL_OPEN_APPSTORE        [DigitInformation shareInstance].g_openAPPStore

#define G_USER                      [DigitInformation shareInstance].g_currentUser


@interface DigitInformation : NSObject

+ (DigitInformation *)shareInstance ;

#pragma mark --
// global token of current user
@property (nonatomic,copy)      NSString        *g_token ;       //当前token

// global current user
@property (nonatomic,strong)    User            *g_currentUser ; // 当前用户

// dataBase
@property (atomic,retain)       FMDatabase      *db;

// 审核开关 , 服务端控制开关
@property (nonatomic)           BOOL            g_openAPPStore ;

// UUID
@property (nonatomic,copy)      NSString        *uuid ;

// QiniuToken
@property (nonatomic,copy)      NSString        *token_QiNiuUpload ;

// cate color
@property (nonatomic,copy)      NSArray         *cateColors ;

@end




