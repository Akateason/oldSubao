//
//  HomeController+TaskModuleTransition.h
//  subao
//
//  Created by TuTu on 16/1/21.
//  Copyright © 2016年 teason. All rights reserved.
//

#import "HomeController.h"

@interface HomeController (TaskModuleTransition)

+ (void)jumpToTopicHomeCtrller:(ArticleTopic *)topic
                 originCtrller:(UIViewController *)ctrller ;

+ (void)jumpToTopicHomeCtrller:(ArticleTopic *)topic
                 originCtrller:(UIViewController *)ctrller
                      animated:(BOOL)animated ;

@end
