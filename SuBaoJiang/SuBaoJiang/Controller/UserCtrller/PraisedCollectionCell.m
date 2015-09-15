//
//  PraisedCollectionCell.m
//  SuBaoJiang
//
//  Created by apple on 15/6/15.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "PraisedCollectionCell.h"
#import "UIImageView+WebCache.h"
#import "XTTickConvert.h"
#import "User.h"
#import "XTCornerView.h"

@interface PraisedCollectionCell ()

@property (weak, nonatomic) IBOutlet UIImageView *img_big;
@property (weak, nonatomic) IBOutlet UILabel *lb_name;
@property (weak, nonatomic) IBOutlet UILabel *lb_date;
@property (weak, nonatomic) IBOutlet UIImageView *img_userhead;

@end

@implementation PraisedCollectionCell

- (void)awakeFromNib
{
    // Initialization code
    
    [XTCornerView setRoundHeadPicWithView:_img_userhead] ;
    _img_userhead.layer.borderColor = COLOR_USERHEAD_BORDER.CGColor ;
    _img_userhead.layer.borderWidth = ONE_PIXEL_VALUE ;
    _img_userhead.contentMode = UIViewContentModeScaleAspectFit ;
    
    self.backgroundColor = [UIColor whiteColor] ;
}

- (void)setPraise:(ArticlePraise *)praise
{
    _praise = praise ;
    
    [_img_big sd_setImageWithURL:[NSURL URLWithString:_praise.img]  placeholderImage:IMG_NOPIC] ;
    [_img_userhead sd_setImageWithURL:[NSURL URLWithString:_praise.user.u_headpic]  placeholderImage:IMG_HEAD_NO] ;
    
    _lb_name.text = _praise.user.u_nickname ;
    _lb_date.text = [XTTickConvert timeInfoWithDate:[XTTickConvert getNSDateWithTick:_praise.p_createTime]] ;
}

@end
