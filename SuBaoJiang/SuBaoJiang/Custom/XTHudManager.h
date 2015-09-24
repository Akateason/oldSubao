//
//  TeaHudManager.h
//  SuBaoJiang
//
//  Created by apple on 15/6/2.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"


@interface XTHudManager : NSObject
//hud
@property (nonatomic,retain)    MBProgressHUD   *HUD ;

+ (XTHudManager *)shareInstance ;

//show normal hud
+ (void)showWordHudWithTitle:(NSString *)title ;
+ (void)showWordHudWithTitle:(NSString *)title
                       delay:(float)delay ;

//show hud animated block
+ (void)showHudWhileExecutingBlock:(dispatch_block_t)block AndComplete:(dispatch_block_t)complete AndWithMinSec:(float)sec ;

@end
