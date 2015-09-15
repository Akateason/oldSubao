//
//  GuideSecondCtrller.m
//  SuBaoJiang
//
//  Created by apple on 15/6/23.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "GuideSecondCtrller.h"

@interface GuideSecondCtrller ()
@property (weak, nonatomic) IBOutlet UIImageView *lb_word1;
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UIImageView *lb_word2;
@end

@implementation GuideSecondCtrller

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self allHideInitial] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)allHideInitial
{
    _lb_word1.alpha = 0.0 ;
    _img.alpha = 0.0 ;
    _lb_word2.alpha = 0.0 ;
}

- (void)startAnimate
{
    [self allHideInitial] ;
    
    [UIView animateWithDuration:0.5
                          delay:0.1
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         _lb_word1.alpha = 1.0 ;
                         
                     } completion:^(BOOL finished) {
                         if (finished) {
                            [self towerAnimation] ;
                         }
                     }] ;
}

- (void)towerAnimation
{
    [UIView animateWithDuration:0.5
                          delay:0.4
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         _img.alpha = 1.0 ;

    } completion:^(BOOL finished) {
        if (finished) {
            [self phoneAnimation] ;
        }
    }] ;
}

- (void)phoneAnimation
{

    [UIView animateWithDuration:0.55 delay:0.4 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _img.alpha = 1.0 ;

    } completion:^(BOOL finished) {
        if (finished) {
            [self wordsAnimation] ;
        }
    }] ;
}

- (void)wordsAnimation
{
    [UIView animateWithDuration:0.1 delay:0.2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _lb_word2.alpha = 1.0 ;
    } completion:^(BOOL finished) {
        if (finished) {
            [XTAnimation animationRippleEffect:_lb_word2] ;
        }
    }] ;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
