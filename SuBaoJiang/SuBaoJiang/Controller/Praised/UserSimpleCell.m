//
//  UserSimpleCell.m
//  SuBaoJiang
//
//  Created by apple on 15/6/8.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "UserSimpleCell.h"
#import "UIImageView+WebCache.h"
#import "User.h"
#import "XTCornerView.h"

@interface UserSimpleCell ()

@property (weak, nonatomic) IBOutlet UIImageView *img_head ;
@property (weak, nonatomic) IBOutlet UILabel *lb_name ;

@end

@implementation UserSimpleCell

- (void)awakeFromNib
{
    // Initialization code
    
    [XTCornerView setRoundHeadPicWithView:_img_head] ;
    _img_head.layer.borderColor = COLOR_USERHEAD_BORDER.CGColor ;
    _img_head.layer.borderWidth = ONE_PIXEL_VALUE ;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setPraise:(ArticlePraise *)praise
{
    _praise = praise ;
    
    [_img_head sd_setImageWithURL:[NSURL URLWithString:praise.user.u_headpic] placeholderImage:IMG_HEAD_NO] ;
    
    _lb_name.text = _praise.user.u_nickname ;
}

@end
