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
#import "AFViewShaker.h"

@interface UserInfoView ()
@property (weak, nonatomic) IBOutlet UILabel *lb_userInfo;
@property (weak, nonatomic) IBOutlet UIImageView *img_head;
@property (weak, nonatomic) IBOutlet UILabel *lb_uname;
@property (weak, nonatomic) IBOutlet UIView *v_line;
@end

@implementation UserInfoView

- (void)animationForUserHead
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSArray * viewlist = @[_img_head,_lb_uname] ;
        AFViewShaker *viewShaker = [[AFViewShaker alloc] initWithViewsArray:viewlist];
        [viewShaker shake] ;
        
    }) ;
    
}


#pragma mark - Properties
- (void)setTheUser:(User *)theUser
{
    _theUser = theUser ;
    
    _lb_uname.text = (!theUser.u_id) ? @"点我登录" : theUser.u_nickname ;
    
    _lb_userInfo.text = ( !theUser.u_description || ![theUser.u_description length] ) ? @"暂无简介" : theUser.u_description ;
    
    [_img_head sd_setImageWithURL:[NSURL URLWithString:theUser.u_headpic]
                 placeholderImage:IMG_HEAD_NO] ;
    
}

- (void)awakeFromNib
{
    // Initialization code
    
    _img_head.layer.borderColor = [UIColor whiteColor].CGColor ;
    _img_head.layer.borderWidth = 1.0 ;
    
    [XTCornerView setRoundHeadPicWithView:_img_head] ;
    
    self.backgroundColor = nil ;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
