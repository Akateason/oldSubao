//
//  NewCameaCtrller.h
//  SuBaoJiang
//
//  Created by apple on 15/6/24.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "RootCtrl.h"
#import "AlbumnCell.h"
#define MAX_SELECT_COUNT    50

@class Article ;

@interface NewCameaCtrller : RootCtrl
@property (nonatomic) Mode_SingleOrMultiple fetchMode ;
@property (nonatomic,copy)      NSString    *topicStr ;
@property (nonatomic,strong)    Article     *articleSuper ;
@property (nonatomic,strong)    UIViewController *orginCtrller ;
@property (nonatomic)           int         existedSubArticleCount ; // default is 0
@property (nonatomic)           int         bigestLastArticleClientID ;
@end
