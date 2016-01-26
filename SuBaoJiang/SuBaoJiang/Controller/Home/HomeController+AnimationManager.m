//
//  HomeController+AnimationManager.m
//  subao
//
//  Created by TuTu on 16/1/21.
//  Copyright © 2016年 teason. All rights reserved.
//

#import "HomeController+AnimationManager.h"

@implementation HomeController (AnimationManager)

- (void)reverseImageSendAnimationWithRect:(CGRect)toRect
{
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:toRect] ;
    imgView.image = self.imgTempWillSend ;
    [self.view addSubview:imgView] ;
    [self scaleImageView:imgView FromRect:self.fromRect] ;
}

- (void)selfViewFadeIn
{
    self.view.alpha = 0.1 ;
    [UIView animateWithDuration:0.65
                     animations:^{
                         self.view.alpha = 1. ;
                     }] ;

}

- (void)scaleImageView:(UIImageView *)imgView FromRect:(CGRect)fromRect
{
    [UIView animateWithDuration:QUICKLY_ANIMATION_DURATION
                     animations:^{
                         
                         imgView.frame = fromRect ;
                         
                     } completion:^(BOOL finished) {
                         if (finished) {
                             [imgView removeFromSuperview] ;
                         }
                     }] ;

}

@end
