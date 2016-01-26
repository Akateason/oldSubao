//
//  HomeUserTableHeaderView.m
//  subao
//
//  Created by TuTu on 16/1/5.
//  Copyright © 2016年 teason. All rights reserved.
//

#import "HomeUserTableHeaderView.h"
//#import "SuBaoHeaderView.h"
#import "UIImageView+WebCache.h"
#import "User.h"
#import "XTTickConvert.h"
#import "UIImage+AddFunction.h"
#import "UIImage+RoundedCorner.h"
#import "Article.h"

@interface HomeUserTableHeaderView ()

@property (weak, nonatomic) IBOutlet UIImageView    *img_user;
@property (weak, nonatomic) IBOutlet UILabel        *lb_uName;
@property (weak, nonatomic) IBOutlet UILabel        *lb_date;

@end

@implementation HomeUserTableHeaderView

- (IBAction)tapHeadAction:(id)sender
{
    [self.delegate clickUserHead:_article.userCurrent.u_id] ;
}


- (instancetype)initWithReuseIdentifier:(nullable NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier] ;
    if (self) {
        
    }
    return self ;
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder] ;
    if (self) {
        
    }
    return self ;
}

- (void)setup
{
    _img_user.layer.cornerRadius = _img_user.frame.size.width / 2.0 ;
    _img_user.layer.borderWidth = ONE_PIXEL_VALUE ;
    _img_user.layer.borderColor = COLOR_USERHEAD_BORDER.CGColor ;
    _img_user.layer.masksToBounds = YES ;
    _img_user.layer.drawsAsynchronously = YES ;
    
    self.backgroundView = ({
        UIView *back = [[UIView alloc] initWithFrame:self.bounds] ;
        back.backgroundColor = [UIColor whiteColor] ;
        back ;
    }) ;
}

- (void)awakeFromNib
{
    [self setup] ;
}

- (void)setArticle:(Article *)article
{
    _article = article ;
    
    _lb_uName.text = article.userCurrent.u_nickname;
    
    NSDate *update = [XTTickConvert getNSDateWithTick:article.a_updatetime] ;
    _lb_date.text = (!article.a_updatetime) ? @"" : [XTTickConvert timeInfoWithDate:update] ;
    
    [_img_user sd_setImageWithURL:[NSURL URLWithString:article.userCurrent.u_headpic]
                 placeholderImage:IMG_HEAD_NO
                        completed:nil] ;
    
    if (!article.a_id && !article.client_AID)
    {
        _lb_uName.text = @"暂无" ;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


@end
