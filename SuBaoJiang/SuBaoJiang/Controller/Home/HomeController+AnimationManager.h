//
//  HomeController+AnimationManager.h
//  subao
//
//  Created by TuTu on 16/1/21.
//  Copyright © 2016年 teason. All rights reserved.
//

#import "HomeController.h"

@interface HomeController (AnimationManager)

- (void)reverseImageSendAnimationWithRect:(CGRect)toRect ;

- (void)selfViewFadeIn ;

- (void)scaleImageView:(UIImageView *)imgView FromRect:(CGRect)fromRect ;

@end
