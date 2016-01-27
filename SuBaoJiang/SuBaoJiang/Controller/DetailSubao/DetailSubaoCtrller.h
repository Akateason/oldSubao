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
#import "HomeController.h"

@interface DetailSubaoCtrller : RootCtrl

@property (nonatomic)               int                superArticleID ; // current super article ID ;
@property (nonatomic)               int                replyCommentID ; // exist when reply it ;

@property (nonatomic)               CGRect             fromRect ;
@property (nonatomic)               CGRect             toRect ;
@property (nonatomic,strong)        UIImage            *imgArticleSend ;

@property (nonatomic,strong)        HomeController     *homeCtrller ;
- (void)startReverseAnmation ;

@end
