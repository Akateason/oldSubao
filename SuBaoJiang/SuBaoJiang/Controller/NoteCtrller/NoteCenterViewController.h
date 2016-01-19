//
//  NoteCenterViewController.h
//  SuBaoJiang
//
//  Created by apple on 15/7/31.
//  Copyright (c) 2015年 teason. All rights reserved.

// New Note Ctrller In 1.1 @ADD@

#import "RootCtrl.h"
#import "PublicEnum.h"

@interface NoteCenterViewController : RootCtrl

- (void)clearSavingCount ;

+ (void)updateAlreadyReadMsglist:(NSArray *)msglist
                            mode:(MODE_NOTE)mode ;
@end
