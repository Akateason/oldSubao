//
//  ShareUtils.m
//  SuBaoJiang
//
//  Created by apple on 15/7/24.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "ShareUtils.h"
#import "WeiboSDK.h"
#import "AppDelegate.h"
#import "User.h"
#import "DigitInformation.h"
#import "CommonFunc.h"

@implementation ShareUtils

#pragma mark - share string .
+ (NSString *)shareContent:(Article *)article
                    urlStr:(NSString *)urlString
                   isMulty:(BOOL)isMulty
                    isSelf:(BOOL)isSelf
                  isWeiXin:(BOOL)isWeiXin
{
    if (isWeiXin) {
        urlString = @"" ;
    }
    
    NSString *resultString = @"" ;
    if (isMulty) {
        if (isSelf) {
            resultString = [NSString stringWithFormat:@"我在#速报酱#上发布了我的速报:%@,大家快来围观%@",article.a_title,urlString] ;
        }
        else {
            resultString = [NSString stringWithFormat:@"我要推荐:%@,图文来自%@,发现日本的最流行尽在#速报酱#%@",article.a_title,article.userCurrent.u_nickname,urlString] ;

        }
    }
    else {
        NSString *contentStr = article.a_content ;
        contentStr = (![contentStr length]) ? @"" : [contentStr stringByAppendingString:@","] ;
        resultString = [NSString stringWithFormat:@"%@来自@%@,发现日本的最流行尽在#速报酱#%@",contentStr,article.userCurrent.u_nickname,urlString] ;

    }
    return resultString ;
}

+ (NSString *)shareContent:(NSString *)content
                    urlStr:(NSString *)urlString
                  isWeiXin:(BOOL)isWeiXin
{
    if (isWeiXin) {
        urlString = @"" ;
    }
    
    content = (![content length]) ? @"" : [content stringByAppendingString:@","] ;

    NSString *resultString = [NSString stringWithFormat:@"%@来自@%@ 发现日本的最流行尽在#速报酱#%@",content,G_USER.u_nickname,urlString] ;
        
    return resultString ;
}

#pragma mark - custom weibo share
+ (void)weiboSilenceShareWithContent:(NSString *)content
                               image:(UIImage *)image
                               topic:(NSString *)topic
                             ctrller:(UIViewController *)ctrller
                           comletion:(UMSocialDataServiceCompletion)completion
{
    image = [CommonFunc getSuBaoJiangWaterMask:image] ;

    NSString *titleStr = (!topic || ![topic length]) ? content : [NSString stringWithFormat:@"#%@#%@",topic,content] ;

//    UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:urlStr] ;
    
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina]
                                                        content:titleStr
                                                          image:image
                                                       location:nil
                                                    urlResource:nil
                                            presentedController:ctrller
                                                     completion:^(UMSocialResponseEntity *shareResponse){
                                                         
                                                         if (shareResponse) {
                                                             completion(shareResponse) ;
                                                         }
//        if (shareResponse.responseCode == UMSResponseCodeSuccess) {
//            NSLog(@"分享成功！");
//        }
    }] ;
}


+ (void)weiboShareFuncWithContent:(NSString *)content
                            image:(UIImage *)image
                            topic:(NSString *)topic
                          ctrller:(UIViewController *)ctrller
{
    image = [CommonFunc getSuBaoJiangWaterMask:image] ;
    
    AppDelegate *myDelegate =(AppDelegate *)[[UIApplication sharedApplication] delegate] ;
    
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request] ;
    authRequest.redirectURI = WB_REDIRECTURL ;
    authRequest.scope = @"all" ;
    
    WBMessageObject *message = [WBMessageObject message];
    NSString *titleStr = (!topic || ![topic length]) ? content : [NSString stringWithFormat:@"#%@#%@",topic,content] ;
    message.text = titleStr ;
    WBImageObject *imageObj = [WBImageObject object] ;
    imageObj.imageData = UIImageJPEGRepresentation(image,1) ;
    message.imageObject = imageObj ;
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message authInfo:authRequest access_token:myDelegate.wbtoken] ;
    [WeiboSDK sendRequest:request] ;
}


#pragma mark - custom weiXin share
+ (void)weixinShareFuncContent:(NSString *)content
                         image:(UIImage *)image
                         topic:(NSString *)topic
                           url:(NSString *)urlStr
                       ctrller:(UIViewController *)ctrller
{
    image = [CommonFunc getSuBaoJiangWaterMask:image] ;

    // 要跳的链接
    [UMSocialData defaultData].extConfig.wechatSessionData.url = urlStr ;
    // 朋友圈title
    NSString *titleStr = (!topic) ? content : [NSString stringWithFormat:@"#%@#%@",topic,content] ;
    [UMSocialData defaultData].extConfig.wechatSessionData.title = titleStr ;
    
    //使用UMShareToWechatSession,UMShareToWechatTimeline,UMShareToWechatFavorite分别代表微信好友、微信朋友圈、微信收藏
    [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToWechatSession] content:content image:image location:nil urlResource:nil presentedController:ctrller completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess)
        {
            NSLog(@"分享成功！");
        }
    }];
}

#pragma mark - custom weiXin Friend share
+ (void)wxFriendShareFuncContent:(NSString *)content
                           image:(UIImage *)image
                           topic:(NSString *)topic
                             url:(NSString *)urlStr
                         ctrller:(UIViewController *)ctrller

{
    image = [CommonFunc getSuBaoJiangWaterMask:image] ;

    // 要跳的链接
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = urlStr ;
    // 朋友圈title
    NSString *titleStr = (!topic) ? content : [NSString stringWithFormat:@"#%@#%@",topic,content] ;
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = titleStr ;
    
    //使用UMShareToWechatSession,UMShareToWechatTimeline,UMShareToWechatFavorite分别代表微信好友、微信朋友圈、微信收藏
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:content image:image location:nil urlResource:nil presentedController:ctrller completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess)
        {
            NSLog(@"分享成功！");
        }
    }];
}

@end
