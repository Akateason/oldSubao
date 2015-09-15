//
//  GuideFirstCtrller.m
//  SuBaoJiang
//
//  Created by apple on 15/6/23.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "GuideFirstCtrller.h"

@interface GuideFirstCtrller ()
@property (weak, nonatomic) IBOutlet UIImageView *lb_word1;
@property (weak, nonatomic) IBOutlet UIImageView *img_map;
@property (weak, nonatomic) IBOutlet UIImageView *lb_word2;

@end

@implementation GuideFirstCtrller

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.myTitle = @"引导页" ;
    
    [self allHideInitial] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)allHideInitial
{
    _lb_word1.alpha = 0.0 ;
    _img_map.alpha = 0.0 ;
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
                         [self objectA] ;
                     }] ;
}

- (void)objectA
{
    _img_map.alpha = 1.0 ;

    [UIView animateWithDuration:0.6
                          delay:0.4
                        options:(UIViewAnimationOptionCurveEaseInOut) animations:^{

                            [XTAnimation animationRotateAndScaleDownUp:_img_map] ;
                            
    } completion:^(BOOL finished) {
        if (finished) {
            [self boxAnimate] ;
        }
    }] ;
}



- (void)boxAnimate
{
    [UIView animateWithDuration:0.1f
                          delay:0.8
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
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
