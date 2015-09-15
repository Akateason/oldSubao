//
//  DetailSubaoCtrller.h
//  SuBaoJiang
//
//  Created by apple on 15/6/2.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "RootCtrl.h"
#import "Article.h"
#import "NotificationCenterHeader.h"

@interface DetailSubaoCtrller : RootCtrl

@property (nonatomic) int superArticleID ; // current super article ID ;
@property (nonatomic) int replyCommentID ; // exist when reply it ;

+ (void)jump2DetailSubaoCtrller:(UIViewController *)ctrller
               AndWithArticleID:(int)aID ;

+ (void)jump2DetailSubaoCtrller:(UIViewController *)ctrller
               AndWithArticleID:(int)aID
               AndWithCommentID:(int)commentID ;

+ (void)jump2DetailSubaoCtrller:(UIViewController *)ctrller
               AndWithArticleID:(int)aID
               AndWithCommentID:(int)commentID
                       FromRect:(CGRect)fromRect
                        imgSend:(UIImage *)imgSend ;
@end
