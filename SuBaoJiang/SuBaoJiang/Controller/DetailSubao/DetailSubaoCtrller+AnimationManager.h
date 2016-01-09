//
//  DetailSubaoCtrller+AnimationManager.h
//  subao
//
//  Created by TuTu on 16/1/8.
//  Copyright © 2016年 teason. All rights reserved.
//

#import "DetailSubaoCtrller.h"

@interface DetailSubaoCtrller (AnimationManager)

+ (void)loadLikeAnimation:(UIView * __nullable)targetView
               completion:(void (^ __nullable)(BOOL finished))completion ;

+ (void)loadLikeAnimation:(UIView * __nullable)targetView
                    delay:(float)delay
               completion:(void (^ __nullable)(BOOL finished))completion ;

@end
