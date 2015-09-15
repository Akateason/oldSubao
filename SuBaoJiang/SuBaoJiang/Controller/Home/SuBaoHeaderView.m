//
//  SuBaoHeaderView.m
//  SuBaoJiang
//
//  Created by apple on 15/6/2.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "SuBaoHeaderView.h"
#import "XTCornerView.h"
#import "UIImageView+WebCache.h"
#import "User.h"
#import "XTTickConvert.h"
#import "UIImage+AddFunction.h"

@interface SuBaoHeaderView ()

@property (weak, nonatomic) IBOutlet UIImageView    *img_user;
@property (weak, nonatomic) IBOutlet UILabel        *lb_uName;
@property (weak, nonatomic) IBOutlet UILabel        *lb_date;

@end

@implementation SuBaoHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)tapHeadAction:(id)sender
{
    [self.delegate clickUserHead:_article.userCurrent.u_id] ;
}

- (void)awakeFromNib
{
    [XTCornerView setRoundHeadPicWithView:_img_user] ;
    _img_user.layer.borderWidth = ONE_PIXEL_VALUE ;
    _img_user.layer.borderColor = COLOR_USERHEAD_BORDER.CGColor ;
}

- (void)setArticle:(Article *)article
{
    _article = article ;
    
    _lb_uName.text = article.userCurrent.u_nickname;
    
    NSDate *update = [XTTickConvert getNSDateWithTick:article.a_updatetime] ;
    _lb_date.text = (!article.a_updatetime) ? @"" : [XTTickConvert timeInfoWithDate:update] ;

    [_img_user sd_setImageWithURL:[NSURL URLWithString:article.userCurrent.u_headpic]
                 placeholderImage:IMG_HEAD_NO] ;
    
    if (!article.a_id && !article.client_AID) {
        _lb_uName.text = @"暂无" ;
    }
}

@end
