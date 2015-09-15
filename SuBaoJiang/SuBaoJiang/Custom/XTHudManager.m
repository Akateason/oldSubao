//
//  TeaHudManager.m
//  SuBaoJiang
//
//  Created by apple on 15/6/2.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "XTHudManager.h"
#import "DigitInformation.h"
#import "NSObject+MKBlockTimer.h"


static XTHudManager *instance ;

@implementation XTHudManager
+ (XTHudManager *)shareInstance
{
    if (instance == nil) {
        instance = [[[self class] alloc] init];
    }
    return instance;
}

#pragma mark --
#pragma mark - SHOW HUD
+ (void)showWordHudWithTitle:(NSString *)title
{
    [self showWordHudWithTitle:title delay:1.3f] ;
}

+ (void)showWordHudWithTitle:(NSString *)title
                       delay:(float)delay
{
    //自定义view
    if (![XTHudManager shareInstance].HUD)
    {
        [XTHudManager shareInstance].HUD = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
        [[UIApplication sharedApplication].keyWindow addSubview:[XTHudManager shareInstance].HUD];
    }
    
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:[XTHudManager shareInstance].HUD] ;
    [[XTHudManager shareInstance].HUD show:YES] ;
    
    [XTHudManager shareInstance].HUD.detailsLabelText = title ;
    [XTHudManager shareInstance].HUD.dimBackground = NO ;
    [XTHudManager shareInstance].HUD.mode = MBProgressHUDModeText ;
    [[XTHudManager shareInstance].HUD hide:YES afterDelay:delay] ;
}




+ (void)showHudWhileExecutingBlock:(dispatch_block_t)block AndComplete:(dispatch_block_t)complete AndWithMinSec:(float)sec
{
    
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0) ;
    dispatch_async(queue, ^{
        
        __block unsigned int seconds = [self logTimeTakenToRunBlock:^{
            block();
        } withPrefix:@"result time"] ;
        
        float smallsec = seconds / 1000.0f ;
        if (sec > smallsec) {
            float stayTime = sec - smallsec ;
            dispatch_async(dispatch_get_main_queue(), ^() {
                sleep(stayTime) ;
                complete();
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^() {
                complete();
            });
        }
    });
}




@end
