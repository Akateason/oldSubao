//
//  DetailSubaoCtrller+AnimationManager.m
//  subao
//
//  Created by TuTu on 16/1/8.
//  Copyright © 2016年 teason. All rights reserved.
//

#import "DetailSubaoCtrller+AnimationManager.h"

@implementation DetailSubaoCtrller (AnimationManager)

- (void)imageSendAnimationWithisMultyType:(BOOL)isMulty
                           imgAnimateView:(UIImageView * __nullable)imgAnimateView
{
    if (self.imgArticleSend != nil)
    {
        self.view.alpha = 0 ;
        [UIView animateWithDuration:QUICKLY_ANIMATION_DURATION
                         animations:^{
                             CGFloat yFlex = isMulty ? 48.0f + 52.0f : 48.0f ;
                             imgAnimateView.frame = CGRectMake(0, yFlex, APPFRAME.size.width, APPFRAME.size.width) ;
                             self.toRect = imgAnimateView.frame ;
                             self.view.alpha = 1. ;
                         } completion:^(BOOL finished) {
                             if (finished) {
                                 imgAnimateView.hidden = YES ;
                             }
                         }] ;
    }
}

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

- (void)suspendButtonRunAnimation:(BOOL)showOrHide
                           likeBt:(UIButton * __nullable)likeButton
                          shareBt:(UIButton * __nullable)shareButton
{
    if (!likeButton) return ;
    
    if (showOrHide) {
        if (likeButton != nil && likeButton.alpha != 1.0)
        {
            [UIView animateWithDuration:0.35
                             animations:^{
                                 
                                 likeButton.alpha = 1.0 ;
                                 shareButton.alpha = 1.0 ;
                                 
                                 likeButton.layer.shadowOffset = CGSizeMake(3,3);
                                 shareButton.layer.shadowOffset = CGSizeMake(3,3);
                                 likeButton.layer.shadowOpacity = 0.6;
                                 shareButton.layer.shadowOpacity = 0.6;

                             }];
        }
    }
    else {
        [UIView animateWithDuration:0.35
                         animations:^{
                             
                             likeButton.alpha = 0.35 ;
                             shareButton.alpha = 0.35 ;
                             
                             likeButton.layer.shadowOffset = CGSizeMake(0,0);
                             shareButton.layer.shadowOffset = CGSizeMake(0,0);
                             likeButton.layer.shadowOpacity = 0.1;
                             shareButton.layer.shadowOpacity = 0.1;

                         }] ;
    }
}


- (void)handleSuspendButton:(UIButton * __nullable)btSuspend
           pullUpOrPullDown:(BOOL)bUpOrDown
{

    [self transformBiggerAnimation:btSuspend
                  pullUpOrPullDown:bUpOrDown] ;

}

static float kBiggerRate        = 1.2 ;
static float kDurationTransf    = 0.3 ;
static float kDurationStrench   = 0.2 ;
static float kDurationPull      = 0.4 ;

- (void)transformBiggerAnimation:(UIView *)whichView
                pullUpOrPullDown:(BOOL)bUpOrDown
{
    if (whichView.alpha != 1.) whichView.alpha = 1. ;

    [UIView animateWithDuration:kDurationTransf
                          delay:0.
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         whichView.transform = CGAffineTransformMakeScale(kBiggerRate, kBiggerRate) ;
                     }
                     completion:^(BOOL finished) {
                         [self reverseAnimation:whichView pullUpOrPullDown:bUpOrDown] ;
                     }] ;
}

- (void)reverseAnimation:(UIView *)whichView
        pullUpOrPullDown:(BOOL)bUpOrDown

{
    [UIView transitionWithView:whichView
                      duration:kDurationStrench
                       options:UIViewAnimationOptionTransitionFlipFromTop
                    animations:^{
                            whichView.transform = CGAffineTransformIdentity ;
                    }
                    completion:^(BOOL finished) {
                        [self pullDownAnimation:whichView pullUpOrPullDown:bUpOrDown] ;
                    }] ;
    
}

- (void)pullDownAnimation:(UIView *)whichView
         pullUpOrPullDown:(BOOL)bUpOrDown
{
    CGRect orgRect = whichView.frame ;
    orgRect.origin.y = - kSuspendButtonWidth ;
    
    CGRect newRect = orgRect ;
    newRect.origin.y = kSuspendButtonOrginY ;
    
    [UIView animateWithDuration:kDurationPull
                          delay:0.
         usingSpringWithDamping:0.5
          initialSpringVelocity:10.
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         whichView.frame = !bUpOrDown ? orgRect : newRect ;
                     } completion:^(BOOL finished) {
                         
                     }] ;
    
}

- (void)runTransitionAnimationWithButtonOne:(UIButton * __nullable)bt1
                                  ButtonTwo:(UIButton * __nullable)bt2
                           pullUpOrPullDown:(BOOL)bUpOrDown
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self handleSuspendButton:bt1 pullUpOrPullDown:bUpOrDown] ;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)) , dispatch_get_main_queue(), ^{

            [self handleSuspendButton:bt2 pullUpOrPullDown:bUpOrDown] ;
        }) ;
    }) ;
}

+ (CGRect)getRectOfBtSuspendLike
{
    CGRect likeFrame = CGRectZero ;
    likeFrame.origin = CGPointMake(APPFRAME_WIDTH - kRightDistance_SuspendButton - kSuspendButtonWidth ,
                                   - kSuspendButtonWidth) ;
    likeFrame.size = CGSizeMake(kSuspendButtonWidth, kSuspendButtonWidth) ;
    return likeFrame ;
}

+ (CGRect)getRectOfBtSuspendShare
{
    CGRect shareFrame = CGRectZero ;
    shareFrame.size = CGSizeMake(kSuspendButtonWidth, kSuspendButtonWidth) ;
    shareFrame.origin = CGPointMake(APPFRAME_WIDTH - kRightDistance_SuspendButton - kSuspendButtonWidth * 2 - kBtDistance , - kSuspendButtonWidth) ;
    return shareFrame ;
}

@end
