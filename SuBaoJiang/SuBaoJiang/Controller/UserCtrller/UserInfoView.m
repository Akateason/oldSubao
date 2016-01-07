//
//  UserInfoView.m
//  subao
//
//  Created by apple on 15/9/2.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "UserInfoView.h"
#import "XTCornerView.h"
#import "UIImageView+WebCache.h"
#import "UIImage+AddFunction.h"
#import "DigitInformation.h"
#import "XTAnimation.h"
#import "UIImage+RoundedCorner.h"

@interface UserInfoView ()

@property (weak, nonatomic) IBOutlet UILabel *lb_userInfo;
@property (weak, nonatomic) IBOutlet UIImageView *img_head;
@property (weak, nonatomic) IBOutlet UIImageView *img_sex;
@property (weak, nonatomic) IBOutlet UILabel *lb_uname;
@property (weak, nonatomic) IBOutlet UIView *v_line;
@property (weak, nonatomic) IBOutlet UIButton *bt_edit;

@end

@implementation UserInfoView

- (void)setRotateAnimationProgress:(float)time
{
    _img_head.layer.timeOffset = time ;
    _v_line.layer.timeOffset = time ;
}

- (void)setOtherFaceAnimation:(float)time
{
    _lb_uname.layer.timeOffset = time ;
    _lb_userInfo.layer.timeOffset = time ;
    _bt_edit.layer.timeOffset = time ;
    _v_line.layer.timeOffset = time ;
}

#pragma mark - Properties
- (void)setTheUser:(User *)theUser
{
    _theUser = theUser ;
    
    _lb_uname.hidden = !theUser ;
    _lb_uname.text = (!theUser.u_id) ? @"点我登录" : theUser.u_nickname ;

    _lb_userInfo.hidden = !theUser ;
    _lb_userInfo.text = ( !theUser.u_description || ![theUser.u_description length] ) ? @"暂无简介" : theUser.u_description ;
    
    [_img_head sd_setImageWithURL:[NSURL URLWithString:theUser.u_headpic]
                 placeholderImage:IMG_HEAD_NO] ;
    
    NSString *genderImgStr = [theUser getUserSexImageString] ;
    _img_sex.hidden = (genderImgStr == nil) ;
    if (genderImgStr) _img_sex.image = [UIImage imageNamed:genderImgStr] ;
    
    BOOL isOwner = [theUser isCurrentUserBeOwner] ;
    _bt_edit.hidden = !isOwner ;
}

- (void)awakeFromNib
{
    // Initialization code
    self.backgroundColor = nil ;
    //
    _img_head.layer.borderColor = [UIColor whiteColor].CGColor ;
    _img_head.layer.borderWidth = 1.0 ;
    [XTCornerView setRoundHeadPicWithView:_img_head] ;
    [XTCornerView setRoundHeadPicWithView:_bt_edit] ;    
    _bt_edit.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4] ;
    _bt_edit.hidden = YES ;
    //
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMe:)] ;
    [self addGestureRecognizer:tap] ;
    //
    [self setupImgHeadAnimation] ;
    //
    [self setupOtherFadeAnimation] ;
    //
    [self setupLineMinusAnimation] ;
}

- (void)setupImgHeadAnimation
{
    float degree = M_PI ;
    CATransform3D rotationTransform = CATransform3DMakeRotation(degree, 0, 0 ,1);
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.toValue = [NSValue valueWithCATransform3D:rotationTransform];
    animation.cumulative = YES ;
    animation.duration = 1 ;
    animation.repeatCount = 20 ;
    animation.removedOnCompletion = NO ;
    [_img_head.layer addAnimation:animation forKey:@"rotateUserHead"] ;
    _img_head.layer.speed = 0 ;
    _img_head.layer.timeOffset = 0 ;
}

- (void)setupOtherFadeAnimation
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"] ;
    animation.fromValue = @1.0 ;
    animation.toValue = @0.2 ;
    animation.duration = 3. ;
    animation.removedOnCompletion = NO ;
    
    [_lb_uname.layer addAnimation:animation forKey:@"alphaAnimation"] ;
    _lb_uname.layer.speed = 0 ;
    _lb_uname.layer.timeOffset = 0 ;
    
    [_lb_userInfo.layer addAnimation:animation forKey:@"alphaAnimation"] ;
    _lb_userInfo.layer.speed = 0 ;
    _lb_userInfo.layer.timeOffset = 0 ;
    
    [_v_line.layer addAnimation:animation forKey:@"alphaAnimation"] ;
    _v_line.layer.speed = 0 ;
    _v_line.layer.timeOffset = 0 ;
    
    [_bt_edit.layer addAnimation:animation forKey:@"alphaAnimation"] ;
    _bt_edit.layer.speed = 0 ;
    _bt_edit.layer.timeOffset = 0 ;
}

- (void)setupLineMinusAnimation
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale.x"] ;
    animation.fromValue = @1.0 ;
    animation.toValue = @0.6 ;
    animation.duration = 3. ;
    animation.removedOnCompletion = NO ;
    [_v_line.layer addAnimation:animation forKey:@"resizeLineAnimation"] ;
    _v_line.layer.speed = 0 ;
    _v_line.layer.timeOffset = 0 ;
}

- (void)tapMe:(UITapGestureRecognizer *)tap
{
    [self.delegate userInfoTappedBackground] ;
}

- (IBAction)editBtClickAction:(id)sender
{
    [self.delegate editBtClick] ;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
