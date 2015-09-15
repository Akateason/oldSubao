//
//  UserCenterController.h
//  SuBaoJiang
//
//  Created by apple on 15/6/9.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "RootCtrl.h"
#import "MyCmtCell.h"

@interface UserCenterController : RootCtrl
<UITableViewDataSource,UITableViewDelegate> //RootTableViewDelegate

@property (nonatomic)           int userID ;
@property (nonatomic)           BOOL noBottom ;

+ (void)jump2UserCenterCtrller:(UIViewController *)ctrller
                     AndUserID:(int)uid ;
@end
