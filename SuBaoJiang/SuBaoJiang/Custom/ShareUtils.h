//
//  ShareUtils.h
//  SuBaoJiang
//
//  Created by apple on 15/7/24.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UMSocial.h"
#import "Article.h"

@interface ShareUtils : NSObject

#pragma mark - share string .
+ (NSString *)shareContent:(Article *)article
                    urlStr:(NSString *)urlString
                   isMulty:(BOOL)isMulty
                    isSelf:(BOOL)isSelf
                  isWeiXin:(BOOL)isWeiXin ;

+ (NSString *)shareContent:(NSString *)content
                    urlStr:(NSString *)urlString
                  isWeiXin:(BOOL)isWeiXin ;

#pragma mark - custom weibo share
+ (void)weiboSilenceShareWithContent:(NSString *)content
                               image:(UIImage *)image
                               topic:(NSString *)topic
                             ctrller:(UIViewController *)ctrller
                           comletion:(UMSocialDataServiceCompletion)completion ;

+ (void)weiboShareFuncWithContent:(NSString *)content
                            image:(UIImage *)image
                            topic:(NSString *)topic
                          ctrller:(UIViewController *)ctrller ;

#pragma mark - custom weiXin share
+ (void)weixinShareFuncContent:(NSString *)content
                         image:(UIImage *)image
                         topic:(NSString *)topic
                           url:(NSString *)urlStr
                       ctrller:(UIViewController *)ctrller ;

#pragma mark - custom weiXin Friend share
+ (void)wxFriendShareFuncContent:(NSString *)content
                           image:(UIImage *)image
                           topic:(NSString *)topic
                             url:(NSString *)urlStr
                         ctrller:(UIViewController *)ctrller ;
@end
