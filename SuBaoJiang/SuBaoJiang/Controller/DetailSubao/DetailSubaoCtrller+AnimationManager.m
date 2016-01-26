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
                                 
                                 likeButton.layer.shadowColor = [UIColor blackColor].CGColor;
                                 likeButton.layer.shadowOffset = CGSizeMake(3,3);
                                 
                                 shareButton.layer.shadowColor = [UIColor blackColor].CGColor;
                                 shareButton.layer.shadowOffset = CGSizeMake(3,3);
                                 
                             }];
        }
    }
    else {
        [UIView animateWithDuration:0.35
                         animations:^{
                             
                             likeButton.alpha = 0.35 ;
                             shareButton.alpha = 0.35 ;
                             
                             likeButton.layer.shadowOffset = CGSizeMake(0,0);
                             likeButton.layer.shadowOpacity = 0.1;
                             
                             shareButton.layer.shadowOffset = CGSizeMake(0,0);
                             shareButton.layer.shadowOpacity = 0.1;
                             
                         }] ;
    }
}


- (void)handleSuspendButton:(UIButton * __nullable)btSuspend
           pullUpOrPullDown:(BOOL)bUpOrDown
{

    [self transformBiggerAnimation:btSuspend
                  pullUpOrPullDown:bUpOrDown] ;
    [self strechAnimation:btSuspend
         pullUpOrPullDown:bUpOrDown] ;
    [self pullDownAnimation:btSuspend
           pullUpOrPullDown:(BOOL)bUpOrDown] ;


}

static float kBiggerRate        = 1.2 ;
static float kDurationTransf    = 0.1 ;
static float kDurationStrench   = 0.3 ;
static float kDurationPull      = 0.4 ;

- (void)transformBiggerAnimation:(UIView *)whichView
                pullUpOrPullDown:(BOOL)bUpOrDown
{
    CGRect imgRect = whichView.frame ;
    
    CGRect rectAboveScreen = imgRect ;
    rectAboveScreen.origin.y =  - whichView.frame.size.height ;
    whichView.frame = rectAboveScreen ;
    
    [UIView animateWithDuration:kDurationTransf
                          delay:0.
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         whichView.transform = CGAffineTransformMakeScale(kBiggerRate, kBiggerRate) ;
                     }
                     completion:^(BOOL finished) {
                     }] ;
}

- (void)strechAnimation:(UIView *)whichView
       pullUpOrPullDown:(BOOL)bUpOrDown

{
    [UIView animateWithDuration:kDurationStrench
                          delay:kDurationTransf + kDurationStrench
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         whichView.transform = CGAffineTransformMakeScale(1, 1.3) ;
                     } completion:^(BOOL finished) {
                         
                         whichView.transform = CGAffineTransformIdentity ;

                     }] ;
}


- (void)pullDownAnimation:(UIView *)whichView
         pullUpOrPullDown:(BOOL)bUpOrDown
{
    CGRect newRect = whichView.frame ;
    newRect.origin.y = [[self class] getRectOfBtSuspendShare].origin.y ;
    
    whichView.frame = bUpOrDown ? whichView.frame : newRect ;
    NSLog(@"whichView.frame : %@", NSStringFromCGRect(whichView.frame)) ;
    float kMoveDistance = kSuspendButtonOrginY + fabs(whichView.frame.origin.y) ;
    NSLog(@"kMoveDistance   : %@", @(kMoveDistance)) ;
    
    [UIView animateWithDuration:kDurationPull
                          delay:kDurationTransf + kDurationStrench + kDurationPull
         usingSpringWithDamping:10.
          initialSpringVelocity:1.
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         whichView.transform = bUpOrDown ? CGAffineTransformMakeTranslation(0, kMoveDistance) : CGAffineTransformMakeTranslation(0, - kMoveDistance) ;
                         
                     } completion:^(BOOL finished) {

                     }] ;
    
}

- (void)runTransitionAnimationWithButtonOne:(UIButton * __nullable)bt1
                                  ButtonTwo:(UIButton * __nullable)bt2
                           pullUpOrPullDown:(BOOL)bUpOrDown
{
    [self handleSuspendButton:bt1 pullUpOrPullDown:bUpOrDown] ;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self handleSuspendButton:bt2 pullUpOrPullDown:bUpOrDown] ;
        // finail complete .
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
