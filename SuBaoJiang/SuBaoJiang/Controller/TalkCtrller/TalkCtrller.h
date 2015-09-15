//
//  TalkCtrller.h
//  SuBaoJiang
//
//  Created by apple on 15/6/12.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "RootCtrl.h"
#import "Acategory.h"

typedef NS_ENUM(NSInteger, TalkCtrller_TopicType) {
    type_default = 0,       // insert and read when post .
    type_suExperience ,     // '速体验合辑'
    type_category           // '话题分类'
} ;

@interface TalkCtrller : RootCtrl<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic) TalkCtrller_TopicType tc_topicType ;
@property (nonatomic,strong) Acategory *acate ; // EXIST IF type_category
@end
