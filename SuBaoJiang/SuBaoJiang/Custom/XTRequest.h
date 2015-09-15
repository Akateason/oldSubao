//
//  TeaRequest.h
//  SuBaoJiang
//
//  Created by apple on 15/6/4.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResultParsered.h"

#define TIMEOUT     10

typedef NS_ENUM(NSInteger, METHOD_REQUEST)
{
    GET_MODE,
    POST_MODE
} ;

@interface XTRequest : NSObject

+ (void)netWorkStatus ;

+ (void)GETWithUrl:(NSString *)url
        parameters:(NSDictionary *)dict
           success:(void (^)(id json))success
              fail:(void (^)())fail ;

+ (void)GETWithUrl:(NSString *)url
               hud:(BOOL)hud
        parameters:(NSDictionary *)dict
           success:(void (^)(id json))success
              fail:(void (^)())fail ;

+ (void)POSTWithUrl:(NSString *)url
         parameters:(NSDictionary *)dict
            success:(void (^)(id json))success
               fail:(void (^)())fail ;

+ (void)POSTWithUrl:(NSString *)url
                hud:(BOOL)hud
         parameters:(NSDictionary *)dict
            success:(void (^)(id json))success
               fail:(void (^)())fail ;

+ (ResultParsered *)getJsonWithURLstr:(NSString *)urlstr
                       AndWithParamer:(NSDictionary *)dict
                          AndWithMode:(METHOD_REQUEST)mode ;

@end
