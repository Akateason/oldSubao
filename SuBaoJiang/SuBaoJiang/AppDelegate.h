//
//  AppDelegate.h
//  SuBaoJiang
//
//  Created by apple on 15/6/1.
//  Copyright (c) 2015年 teason. All rights reserved.
//


#import <UIKit/UIKit.h>
@class NoteCenterViewController ;
@class ThirdLoginCtrller ;
@class PostSubaoCtrller ;
@class MultyEditCtrller ;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window ;

@property (strong, nonatomic) UITabBarController        *tabbarCtrller ;
@property (strong, nonatomic) NoteCenterViewController  *noteCenterCtrller ;
@property (strong, nonatomic) ThirdLoginCtrller         *thirdLoginCtrller ;
@property (strong, nonatomic) PostSubaoCtrller          *postSubaoCtrller ;
@property (strong, nonatomic) MultyEditCtrller          *multyPostCtrller ;
//weibo
@property (strong, nonatomic) NSString *wbtoken ;
@property (strong, nonatomic) NSString *wbCurrentUserID ;
@property (strong, nonatomic) NSString *wbRefreshToken ;

@end

