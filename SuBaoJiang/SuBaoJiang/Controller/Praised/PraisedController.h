//
//  PraisedController.h
//  SuBaoJiang
//
//  Created by apple on 15/6/8.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "RootCtrl.h"

@interface PraisedController : RootCtrl<UITableViewDataSource,UITableViewDelegate,RootTableViewDelegate>

@property (nonatomic)   int    articleID ;

@end
