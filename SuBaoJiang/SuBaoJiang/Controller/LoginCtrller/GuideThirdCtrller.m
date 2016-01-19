//
//  GuideThirdCtrller.m
//  subao
//
//  Created by apple on 15/9/8.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "GuideThirdCtrller.h"
#import "XTAnimation.h"

@interface GuideThirdCtrller ()
@property (weak, nonatomic) IBOutlet UIImageView *word1;
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UIImageView *word2;
@end

@implementation GuideThirdCtrller

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
    _word1.alpha = 0.0 ;
    _img.alpha = 0.0 ;
    _word2.alpha = 0.0 ;
}

- (void)startAnimate
{
    [self allHideInitial] ;
    
    [UIView animateWithDuration:0.5
                          delay:0.1
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         _word1.alpha = 1.0 ;
                         
                     } completion:^(BOOL finished) {
                         if (finished) {
                             [self imgAnimation] ;
                         }
                     }] ;
}

- (void)imgAnimation
{
    [UIView animateWithDuration:0.5
                          delay:0.4
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{

                         _img.alpha = 1.0 ;
                         
                     } completion:^(BOOL finished) {
                         if (finished) {
                             [self endAnimation] ;
                         }
                     }] ;

}

- (void)endAnimation
{
    [UIView animateWithDuration:0.1 delay:0.2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        _word2.alpha = 1.0 ;
        
    } completion:^(BOOL finished) {
        if (finished) {
            [XTAnimation animationRippleEffect:_word2] ;
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
