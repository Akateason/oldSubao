//
//  MultyEditCtrller.h
//  subao
//
//  Created by apple on 15/8/20.
//  Copyright (c) 2015年 teason. All rights reserved.
//


#import "RootCtrl.h"
#import "AlbumnCell.h"
#import "NotificationCenterHeader.h"

@class Article ;

@interface MultyEditCtrller : RootCtrl

- (void)shareArticleNow ;

- (void)insertSubList:(NSArray *)subListWillInsert ;

- (void)changeImageCallback:(UIImage *)realImage ;

+ (void)jump2MultyEditCtrllerWithOrginCtrller:(UIViewController *)ctrller
                                 superArticle:(Article *)superArticle
                                     topicStr:(NSString *)topicStr
                                    childList:(NSMutableArray *)childslist ;

+ (void)finishedChoosePhotosWithImgList:(NSArray *)imgList
                           superArticle:(Article *)superArticle
               bigestSubArticleClientID:(int)bigestSubArticleClientID
                               strTopic:(NSString *)topicStr
                                ctrller:(UIViewController *)ctrller
                          originCtrller:(UIViewController *)orgCtrller ;

@end
