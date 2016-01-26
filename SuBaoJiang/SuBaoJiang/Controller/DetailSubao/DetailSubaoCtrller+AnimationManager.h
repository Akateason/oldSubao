//
//  DetailSubaoCtrller+AnimationManager.h
//  subao
//
//  Created by TuTu on 16/1/8.
//  Copyright © 2016年 teason. All rights reserved.
//
static float kSuspendButtonOrginY           = 50. ;
static float kRightDistance_SuspendButton   = 0. ;
static float kBtDistance                    = 0. ;
static float kSuspendButtonWidth            = 50. ;
static float kSuspendOfEdge                 = 10. ;

#import "DetailSubaoCtrller.h"

@interface DetailSubaoCtrller (AnimationManager)

- (void)imageSendAnimationWithisMultyType:(BOOL)isMulty
                           imgAnimateView:(UIImageView * __nullable)imgAnimateView ;

+ (void)loadLikeAnimation:(UIView * __nullable)targetView
               completion:(void (^ __nullable)(BOOL finished))completion ;

+ (void)loadLikeAnimation:(UIView * __nullable)targetView
                    delay:(float)delay
               completion:(void (^ __nullable)(BOOL finished))completion ;

- (void)suspendButtonRunAnimation:(BOOL)showOrHide
                           likeBt:(UIButton * __nullable)likeButton
                          shareBt:(UIButton * __nullable)shareButton ;


- (void)runTransitionAnimationWithButtonOne:(UIButton * __nullable)bt1
                                  ButtonTwo:(UIButton * __nullable)bt2
                           pullUpOrPullDown:(BOOL)bUpOrDown ;

+ (CGRect)getRectOfBtSuspendLike ;
+ (CGRect)getRectOfBtSuspendShare ;

@end

