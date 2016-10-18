//
//  AppDelegate.m
//  SuBaoJiang
//
//  Created by apple on 15/6/1.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "AppDelegate.h"
#import "DigitInformation.h"
#import "UMSocial.h"
#import "ThirdLoginCtrller.h"
#import "NoteCenterViewController.h"
#import "PostSubaoCtrller.h"
#import "MultyEditCtrller.h"
#import "AppDelegateInitial.h"
#import "WeiboSDK.h"
#import "UMessage.h"
#import "CommonFunc.h"
#import "XTHudManager.h"
#import "ServerRequest.h"

@interface AppDelegate () <WeiboSDKDelegate>

@end

@implementation AppDelegate

#pragma mark --
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [[[AppDelegateInitial alloc] initWithApplication:application options:launchOptions window:_window] setup] ;
    
    return YES ;
}

#pragma mark --
#pragma mark - back ground fetch
- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NSNOTIFICATION_BG_FETCH_NOTES
                                                        object:completionHandler] ;
}

#pragma mark - didReceiveLocalNotification
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    self.tabbarCtrller.selectedIndex = 3 ; // go to note ctrller ;
    [self.noteCenterCtrller clearSavingCount] ;
}

#pragma mark - didReceiveRemoteNotification
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    
}


- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    BOOL result = [UMSocialSnsService handleOpenURL:url] ;
    if (result == FALSE) {
        //调用其他SDK，例如新浪微博SDK等
        return [WeiboSDK handleOpenURL:url delegate:self] ;
    }
    
    return result ;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        //调用其他SDK，例如新浪微博SDK等
        return [WeiboSDK handleOpenURL:url delegate:self] ;
    }
    
    return result ;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [UMessage registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [UMessage didReceiveRemoteNotification:userInfo];
}

#pragma mark --
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

//    NSDate *notifyTime = [NSDate dateWithTimeIntervalSinceNow:10];//触发的时间
//    UILocalNotification *localNofify = [[UILocalNotification alloc] init];
//    localNofify.fireDate = notifyTime;
//    localNofify.timeZone = [NSTimeZone defaultTimeZone];
//    
//    localNofify.alertBody = @"您很久沒有玩了......";
//    localNofify.soundName = UILocalNotificationDefaultSoundName ;
//    localNofify.applicationIconBadgeNumber = 111 ;
//    [[UIApplication sharedApplication] scheduleLocalNotification:localNofify];//注册
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
//    [[TeaPicCacheUploadManager shareInstance] closeLoop] ;
}

#pragma mark --
#pragma mark - Weibo
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
    {
        WBSendMessageToWeiboResponse* sendMessageToWeiboResponse = (WBSendMessageToWeiboResponse*)response ;
        NSString* accessToken = [sendMessageToWeiboResponse.authResponse accessToken];
        if (accessToken) {
            self.wbtoken = accessToken;
        }
        NSString* userID = [sendMessageToWeiboResponse.authResponse userID];
        if (userID) {
            self.wbCurrentUserID = userID;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
//            if (sendMessageToWeiboResponse.statusCode == WeiboSDKResponseStatusCodeSuccess)
//            {
////                [XTHudManager showWordHudWithTitle:WD_HUD_SHARE_SUCCESS] ;
//            }
            [self.postSubaoCtrller shareArticleNow] ;
            [self.multyPostCtrller shareArticleNow] ;
        }) ;
    }
    else if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
        self.wbtoken = [(WBAuthorizeResponse *)response accessToken];
        self.wbCurrentUserID = [(WBAuthorizeResponse *)response userID];
        self.wbRefreshToken = [(WBAuthorizeResponse *)response refreshToken];
        
        NSDictionary *userInfoDic = [ServerRequest getWeiboUserInfoWithToken:self.wbtoken AndWithUid:self.wbCurrentUserID] ;
        
        NSString *userName = [userInfoDic objectForKey:@"screen_name"] ; //用户名
        NSString *avatar_large = [userInfoDic objectForKey:@"avatar_large"] ; //大头图
        NSNumber *gender = @0 ; //性别
        NSString *genderStr = [userInfoDic objectForKey:@"gender"] ;
        if ([genderStr hasPrefix:@"m"]) {
            gender = @1 ;
        }
        else if ([genderStr hasPrefix:@"f"]) {
            gender = @2 ;
        }
        NSString *descrip = [userInfoDic objectForKey:@"description"] ; //描述
        
        [ServerRequest loginUnitWithCategory:mode_WeiBo
                                    wxopenID:nil
                                   wxUnionID:nil
                                    nickName:userName
                                      gender:gender
                                    language:nil
                                     country:nil
                                    province:nil
                                        city:nil
                                     headpic:avatar_large
                                       wbuid:self.wbCurrentUserID
                                 description:descrip
                                    username:nil
                                    password:nil
                                     Success:^(id json) {
            
            ResultParsered *result = [[ResultParsered alloc] initWithDic:json] ;
            [CommonFunc logSussessedWithResult:result
                             AndWithController:self.thirdLoginCtrller] ;
            [CommonFunc bindWithBindMode:mode_weibo] ;
            
        } fail:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [XTHudManager showWordHudWithTitle:WD_HUD_FAIL_RETRY] ;
            }) ;
        }] ;
    }
}

@end
