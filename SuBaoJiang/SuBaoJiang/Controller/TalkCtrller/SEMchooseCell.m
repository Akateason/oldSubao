//
//  SEMchooseCell.m
//  SuBaoJiang
//
//  Created by apple on 15/7/28.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "SEMchooseCell.h"
#import "XTAnimation.h"

@interface SEMchooseCell ()
{
    UIButton *bt_semc_1 ;
    UIButton *bt_semc_2 ;
}
@end

@implementation SEMchooseCell

- (void)awakeFromNib
{
    // Initialization code
    [self drawButtons] ;
    [self drawMiddleLine] ;
}

- (void)drawMiddleLine
{
    CGRect middleRect = CGRectMake(APPFRAME.size.width / 2, 6.0, ONE_PIXEL_VALUE, 52.0) ;
    UIView *middleLine = [[UIView alloc] initWithFrame:middleRect] ;
    middleLine.backgroundColor = [UIColor colorWithRed:209.0/255.0 green:209.0/255.0  blue:209.0/255.0 alpha:1] ;
    [self addSubview:middleLine] ;
}

#define TAG_bt_semc_1       18

- (void)drawButtons
{
    bt_semc_1 = [[[NSBundle mainBundle] loadNibNamed:@"SEMChooseButton" owner:self options:nil] lastObject] ;
    [bt_semc_1 setTitle:@"速体验合辑" forState:0] ;
    bt_semc_1.tag = TAG_bt_semc_1 ;
    bt_semc_1.frame = CGRectMake(0, 0, APPFRAME.size.width / 2, self.frame.size.height) ;
    [bt_semc_1 setImage:[UIImage imageNamed:@"bt_SEMC_1"] forState:0] ;
    [self.contentView addSubview:bt_semc_1] ;
    [bt_semc_1 addTarget:self
                  action:@selector(semcButtonClicked:)
        forControlEvents:UIControlEventTouchUpInside] ;
    
    bt_semc_2 = [[[NSBundle mainBundle] loadNibNamed:@"SEMChooseButton" owner:self options:nil] lastObject] ;
    [bt_semc_2 setTitle:@"话题分类" forState:0] ;
    bt_semc_2.tag = TAG_bt_semc_1 + 1 ;
    bt_semc_2.frame = CGRectMake(APPFRAME.size.width / 2, 0, APPFRAME.size.width / 2, self.frame.size.height) ;
    [bt_semc_2 setImage:[UIImage imageNamed:@"bt_SEMC_2"] forState:0] ;
    [self.contentView addSubview:bt_semc_2] ;
    [bt_semc_2 addTarget:self
                  action:@selector(semcButtonClicked:)
        forControlEvents:UIControlEventTouchUpInside] ;
}

- (void)semcButtonClicked:(UIButton *)button
{
    NSLog(@"semcButtonClicked : %@",@(button.tag)) ;
    
    [self.delegate clickChooseButtonIndex:(int)button.tag - TAG_bt_semc_1] ;
}

static CGFloat duration = 0.7 ;

- (void)animationForIcon
{
    CATransform3D rotationTransform  = CATransform3DMakeRotation(M_PI , 0 , 1 ,0) ;
    
    bt_semc_1.imageView.layer.transform = rotationTransform ;
    [UIView animateWithDuration:duration
                          delay:0
         usingSpringWithDamping:.5
          initialSpringVelocity:10
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         
                         bt_semc_1.imageView.layer.transform = CATransform3DIdentity ;
                         
                     } completion:^(BOOL finished) {
                         
                     }] ;
    
    bt_semc_2.imageView.layer.transform = rotationTransform ;
    [UIView animateWithDuration:duration
                          delay:0.2
         usingSpringWithDamping:.5
          initialSpringVelocity:10
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         
                         bt_semc_2.imageView.layer.transform = CATransform3DIdentity ;
                         
                     } completion:^(BOOL finished) {
                         
                     }] ;
}

- (void)removeAnimation
{
    [bt_semc_1.imageView.layer removeAllAnimations] ;
    [bt_semc_2.imageView.layer removeAllAnimations] ;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
