//
//  HomeController+TaskModuleTransition.m
//  subao
//
//  Created by TuTu on 16/1/21.
//  Copyright © 2016年 teason. All rights reserved.
//

#import "HomeController+TaskModuleTransition.h"
#import "ArticleTopic.h"

@implementation HomeController (TaskModuleTransition)

+ (void)jumpToTopicHomeCtrller:(ArticleTopic *)topic
                 originCtrller:(UIViewController *)ctrller
{
    [self jumpToTopicHomeCtrller:topic originCtrller:ctrller animated:NO] ;
}

+ (void)jumpToTopicHomeCtrller:(ArticleTopic *)topic
                 originCtrller:(UIViewController *)ctrller
                      animated:(BOOL)animated
{
    
    NSArray *ctrllersInNav = [ctrller.navigationController viewControllers] ;
    
    if (!ctrllersInNav || !ctrllersInNav.count) return ;
    
    [ctrllersInNav enumerateObjectsUsingBlock:^(UIViewController *tempCtrl, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([tempCtrl isKindOfClass:[HomeController class]])
        {
            HomeController *homeTempCtrl = (HomeController *)tempCtrl ;
            if (topic.t_id == homeTempCtrl.topicID) {
                [ctrller.navigationController popToViewController:homeTempCtrl animated:YES] ;
                *stop = YES ;
            }
        }
    }] ;
    
    BOOL isKindOfTopicCtrller = [ctrller isKindOfClass:[HomeController class]] ;
    if (isKindOfTopicCtrller) { // current ctrller is Topic
        BOOL isSameTopic = ((HomeController *)ctrller).topic.t_id == topic.t_id ;
        if (isSameTopic) return ; // same Topic Not Jump
    }
    
    if (IS_IOS_VERSION(8.0)) ctrller.navigationController.hidesBarsOnSwipe = NO ;
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil] ;
    HomeController *homeCtrller = [story instantiateViewControllerWithIdentifier:@"HomeController"] ;
    homeCtrller.topic = topic ;
    [homeCtrller setHidesBottomBarWhenPushed:YES] ;
    homeCtrller.tabBarController.tabBar.hidden = YES ;
    [ctrller.navigationController pushViewController:homeCtrller
                                            animated:animated] ;
}


@end
