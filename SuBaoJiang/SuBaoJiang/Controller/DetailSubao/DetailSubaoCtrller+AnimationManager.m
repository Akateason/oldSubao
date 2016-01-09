//
//  DetailSubaoCtrller+AnimationManager.m
//  subao
//
//  Created by TuTu on 16/1/8.
//  Copyright © 2016年 teason. All rights reserved.
//

#import "DetailSubaoCtrller+AnimationManager.h"

@implementation DetailSubaoCtrller (AnimationManager)

static float kSuspendHeartBeatDuration = 0.6 ;

+ (void)loadLikeAnimation:(UIView * __nullable)targetView
               completion:(void (^ __nullable)(BOOL finished))completion
{
    [self loadLikeAnimation:targetView
                      delay:0
                 completion:completion] ;
}

+ (void)loadLikeAnimation:(UIView * __nullable)targetView
                    delay:(float)delay
               completion:(void (^ __nullable)(BOOL finished))completion
{
    [UIView animateKeyframesWithDuration:kSuspendHeartBeatDuration
                                   delay:delay
                                 options:UIViewKeyframeAnimationOptionCalculationModeLinear
                              animations:^{
                                  
                                  [UIView addKeyframeWithRelativeStartTime:0
                                                          relativeDuration:kSuspendHeartBeatDuration / 3
                                                                animations:^{
                                                                    targetView.transform = CGAffineTransformMakeScale(1.3, 1.3) ;
                                                                }] ;
                                  [UIView addKeyframeWithRelativeStartTime:kSuspendHeartBeatDuration / 3
                                                          relativeDuration:kSuspendHeartBeatDuration / 3
                                                                animations:^{
                                                                    targetView.transform = CGAffineTransformMakeScale(1.1, 1.1) ;
                                                                }] ;
                                  [UIView addKeyframeWithRelativeStartTime:kSuspendHeartBeatDuration / 3 * 2
                                                          relativeDuration:kSuspendHeartBeatDuration / 3
                                                                animations:^{
                                                                    targetView.transform = CGAffineTransformMakeScale(1.0, 1.0) ;
                                                                }] ;
                              }
                              completion:completion] ;
}

@end
