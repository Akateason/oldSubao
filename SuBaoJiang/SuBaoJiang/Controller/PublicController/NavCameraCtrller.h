//
//  NavCameraCtrller.h
//  SuBaoJiang
//
//  Created by apple on 15/6/2.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyNavCtrller.h"
#import "AlbumnCell.h"
@class Article ;

@interface NavCameraCtrller : MyNavCtrller

+ (void)jump2NavCameraCtrllerWithOriginCtrller:(UIViewController *)ctrller ;

+ (void)jump2NavCameraCtrllerWithOriginCtrller:(UIViewController *)ctrller
                              AndWithTopicName:(NSString *)topicName ;

+ (void)jump2NavCameraCtrllerWithOriginCtrller:(UIViewController *)ctrller
                              AndWithTopicName:(NSString *)topicName
                                       AndMode:(Mode_SingleOrMultiple)mode ;

+ (void)jump2NavCameraCtrllerWithOriginCtrller:(UIViewController *)ctrller
                              AndWithTopicName:(NSString *)topicName
                                       AndMode:(Mode_SingleOrMultiple)mode
                              AndSuperAriticle:(Article *)superArticle ;

+ (void)jump2NavCameraCtrllerWithOriginCtrller:(UIViewController *)ctrller
                              AndWithTopicName:(NSString *)topicName
                                       AndMode:(Mode_SingleOrMultiple)mode
                              AndSuperAriticle:(Article *)superArticle
                   AndBigestSubArticleClientID:(int)bigestSubArticleCID
                       AndExistSubArticleCount:(int)existCount ;
@end
