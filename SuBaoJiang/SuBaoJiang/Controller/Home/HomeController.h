//
//  HomeController.h
//  SuBaoJiang
//
//  Created by apple on 15/6/2.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "RootCtrl.h"

@class ArticleTopic ;

@interface HomeController : RootCtrl

@property (nonatomic,strong) ArticleTopic *topic    ;
@property (nonatomic)        int           topicID  ;

+ (void)jumpToTopicHomeCtrller:(ArticleTopic *)topic
                 originCtrller:(UIViewController *)ctrller ;

+ (void)jumpToTopicHomeCtrller:(ArticleTopic *)topic
                 originCtrller:(UIViewController *)ctrller
                      animated:(BOOL)animated ;

@end
