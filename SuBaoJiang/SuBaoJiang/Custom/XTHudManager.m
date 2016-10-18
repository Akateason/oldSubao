//
//  TeaHudManager.m
//  SuBaoJiang
//
//  Created by apple on 15/6/2.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "XTHudManager.h"
#import "SVProgressHUD.h"

@implementation XTHudManager


#pragma mark --
#pragma mark - SHOW HUD
+ (void)showWordHudWithTitle:(NSString *)title
{
    [SVProgressHUD showInfoWithStatus:title] ;
}






@end
