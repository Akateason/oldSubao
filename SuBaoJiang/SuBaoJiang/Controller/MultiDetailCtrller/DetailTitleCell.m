//
//  DetailTitleCell.m
//  subao
//
//  Created by apple on 15/8/12.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "DetailTitleCell.h"
#import "Article.h"
#import "ArticleTopic.h"
#import "Acategory.h"
#import "XTBarrageView.h"

@interface DetailTitleCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *flex_left_title;
@property (weak, nonatomic) IBOutlet UIImageView *img_suEx;//速体验
@property (weak, nonatomic) IBOutlet UILabel *lb_type;//分类
@property (weak, nonatomic) IBOutlet UILabel *lb_title;//标题

@end

@implementation DetailTitleCell


- (void)setArticle:(Article *)article
{
    _article = article ;

    //
    ArticleTopic *topic = [article.articleTopicList firstObject] ;
    _flex_left_title.constant = (topic.t_cate == t_cate_type_suExperience && topic != nil) ? 32.0 : 8.0f ;
    _img_suEx.hidden = !(topic.t_cate == t_cate_type_suExperience && topic != nil) ;
    //
    _lb_type.hidden = (!article.ac_content || ![article.ac_content length]) ;
    _lb_type.text = article.ac_content ;
    _lb_type.backgroundColor = [Acategory getCateColorWithCateString:article.ac_content] ;
    //
    _lb_title.text = article.a_title ;
}

#pragma mark --
- (void)awakeFromNib
{
    // Initialization code
    _lb_type.textColor = [UIColor whiteColor] ;
    _lb_type.layer.cornerRadius = CORNER_RADIUS_ALL ;
    _lb_type.layer.masksToBounds = YES ;
    
    _img_suEx.hidden = YES ;
}

+ (CGFloat)calculateHeight:(Article *)article
{
    ArticleTopic *topic = [article.articleTopicList firstObject] ;
    BOOL bSuEx = topic.t_cate == t_cate_type_suExperience ;
    
    UIFont *font = [UIFont systemFontOfSize:20.0f];
//    CGSize size = bSuEx ? CGSizeMake(APPFRAME.size.width - 90.0 - 8.0 - 32.0, 55.0) : CGSizeMake(APPFRAME.size.width - 90.0 - 8.0 - 8.0f, 55.0) ;
    CGSize size = bSuEx ? CGSizeMake(APPFRAME.size.width - 8.0 - 32.0, 55.0) : CGSizeMake(APPFRAME.size.width - 8.0 - 8.0f, 55.0) ;
    
//    CGSize labelsize = [article.a_title sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    CGSize labelsize = [article.a_title boundingRectWithSize:size
                                                     options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                  attributes:@{NSFontAttributeName : font}
                                                     context:nil].size ;
    
    
    CGFloat lbHeight = labelsize.height ;
    if (lbHeight < 24.0)
    {
        lbHeight = 24.0f ;
    }
    
    CGFloat h =  lbHeight + 14.0 * 2 ;
    
    return h ;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
