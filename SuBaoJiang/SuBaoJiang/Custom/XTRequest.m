//
//  TeaRequest.m
//  SuBaoJiang
//
//  Created by apple on 15/6/4.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "XTRequest.h"
#import "AFNetworking.h"
#import "YXSpritesLoadingView.h"

#import "XTJson.h"
#import "ASIFormDataRequest.h"
#import "ASIHTTPRequest.h"


@implementation XTRequest

+ (void)netWorkStatus
{
    /**
     AFNetworkReachabilityStatusUnknown          = -1,  // 未知
     AFNetworkReachabilityStatusNotReachable     = 0,   // 无连接
     AFNetworkReachabilityStatusReachableViaWWAN = 1,   // 3G 花钱
     AFNetworkReachabilityStatusReachableViaWiFi = 2,   // WiFi
     */
    // 如果要检测网络状态的变化,必须用检测管理器的单例的startMonitoring
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    // 检测网络连接的单例,网络变化时的回调方法
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"网络状态 : %@", @(status)) ;
    }];
}

+ (void)GETWithUrl:(NSString *)url
        parameters:(NSDictionary *)dict
           success:(void (^)(id json))success
              fail:(void (^)())fail
{
    [self GETWithUrl:url hud:YES parameters:dict success:success fail:fail] ;
}

+ (void)GETWithUrl:(NSString *)url
               hud:(BOOL)hud
        parameters:(NSDictionary *)dict
           success:(void (^)(id json))success
              fail:(void (^)())fail
{
    if (hud) [YXSpritesLoadingView showWithText:WD_HUD_GOON] ;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = TIMEOUT ;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];//设置相应内容类型
    [manager GET:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
            if (hud) [YXSpritesLoadingView dismiss] ;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error:%@", error);
        if (fail) {
            fail();
            if (hud) [YXSpritesLoadingView dismiss] ;
        }
    }];
}

+ (void)POSTWithUrl:(NSString *)url
                hud:(BOOL)hud
         parameters:(NSDictionary *)dict
            success:(void (^)(id json))success
               fail:(void (^)())fail
{
    if (hud) [YXSpritesLoadingView showWithText:WD_HUD_GOON] ;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];//设置相应内容类型
    manager.requestSerializer.timeoutInterval = TIMEOUT ;

    [manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
            if (hud) [YXSpritesLoadingView dismiss] ;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        if (fail) {
            fail();
            if (hud) [YXSpritesLoadingView dismiss] ;
        }
    }];

}

+ (void)POSTWithUrl:(NSString *)url
         parameters:(NSDictionary *)dict
            success:(void (^)(id json))success
               fail:(void (^)())fail
{
    [self POSTWithUrl:url hud:YES parameters:dict success:success fail:fail] ;
}

+ (ResultParsered *)getJsonWithURLstr:(NSString *)urlstr
         AndWithParamer:(NSDictionary *)dict
            AndWithMode:(METHOD_REQUEST)mode
{
    
    if (mode == GET_MODE) {
        
        NSString *apStr = [self getUrlInGetModeWithDic:dict] ;
        urlstr = [urlstr stringByAppendingString:apStr] ;
        
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlstr]];
        request.timeOutSeconds = TIMEOUT ;
        [request startSynchronous];
        NSError *error = [request error];
        NSString *response;
        if ( error )
        {
            NSLog(@"error:%@",error);
            return nil ;
        }
        response = [request responseString] ;
//        NSLog(@"urlstr : %@\n%@",urlstr,response)  ;
        NSLog(@"urlstr : %@\n",urlstr)  ;

        NSDictionary *dictionary = [XTJson getJsonObj:response] ;
        ResultParsered *result = [[ResultParsered alloc] initWithDic:dictionary] ;
        return result ;
    }
    else if (mode == POST_MODE) {

        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlstr]];
        request.timeOutSeconds = TIMEOUT ;
        
        NSArray *allKeys = [dict allKeys] ;
        for (NSString *key in allKeys)
        {
            NSString *val = [dict objectForKey:key] ;
            [request setPostValue:val forKey:key] ;
        }
        
        [request startSynchronous]                  ;
        
        NSError *error = [request error]            ;
        NSString *response                          ;
        
        if ( error )
        {
            NSLog(@"error:%@",error);
            return nil ;
        }
        response = [request responseString]         ;
//        NSLog(@"urlstr : %@\n%@",urlstr,response)   ;
        NSLog(@"urlstr : %@\n",urlstr)  ;
        NSDictionary *dictionary = [XTJson getJsonObj:response] ;
        ResultParsered *result = [[ResultParsered alloc] initWithDic:dictionary] ;
        
        return result ;
    }
    
    return nil ;
}

+ (NSString *)getUrlInGetModeWithDic:(NSDictionary *)dict
{
    NSArray *allKeys = [dict allKeys] ;
    BOOL bFirst = YES ;
    NSString *appendingStr = @"" ;
    for (NSString *key in allKeys)
    {
        NSString *val = [dict objectForKey:key] ;
        NSString *item = @"";
        if (bFirst) {
            bFirst = NO ;
//            item = [NSString stringWithFormat:@"?%@=%@",key,val] ; //因特殊需求而改动
            item = [NSString stringWithFormat:@"&%@=%@",key,val] ; //因特殊需求而改动
        }
        else
        {
            item = [NSString stringWithFormat:@"&%@=%@",key,val] ;
        }
        
        appendingStr = [appendingStr stringByAppendingString:item] ;
    }
    
    return appendingStr ;
}

@end
