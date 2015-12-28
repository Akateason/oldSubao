//
//  HomeCell.m
//  SuBaoJiang
//
//  Created by apple on 15/6/2.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "HomeCell.h"
#import "UIImageView+WebCache.h"
#import <CoreText/CoreText.h>
#import "NSString+WPAttributedMarkup.h"
#import "WPAttributedStyleAction.h"
#import "WPHotspotLabel.h"
#import "ArticleTopic.h"
#import "ServerRequest.h"
#import "XTBarrageView.h"
#import "DigitInformation.h"
#import "Acategory.h"


@interface HomeCell () <ArticleDelegate>
{
    XTBarrageView       *m_barrageView ;
}
// single photo
@property (weak, nonatomic) IBOutlet UIImageView *img_big;
@property (weak, nonatomic) IBOutlet UILabel *lb_commentCount_likeCout;
@property (weak, nonatomic) IBOutlet WPHotspotLabel *lb_comment;
@property (weak, nonatomic) IBOutlet UIButton *bt_likeOrNot;

// multiple photos
@property (weak, nonatomic) IBOutlet UIView *multiSuperView;
@property (weak, nonatomic) IBOutlet UIImageView *img_tag_suEx;
@property (weak, nonatomic) IBOutlet UILabel *lb_title;
@property (weak, nonatomic) IBOutlet UILabel *lb_type;

@end

@implementation HomeCell

#pragma mark - ArticleDelegate
- (void)topicHotPotClicked
{
    [self.delegate topicSelected:[[self.article articleTopicList] firstObject]] ;
}

- (void)dealloc
{
    [m_barrageView stop] ;
    m_barrageView = nil ;
}

- (void)awakeFromNib
{
    // Initialization code
    self.exclusiveTouch = YES ;
    self.contentView.backgroundColor = COLOR_BACKGROUND ;
    
    self.contentView.bounds = [UIScreen mainScreen].bounds;

    //多图
    [self setupMultiple] ;
    
    //弹幕
    [self setupBarrageView] ;
}

- (void)setupMultiple
{
    _multiSuperView.backgroundColor = nil ;
    _multiSuperView.clipsToBounds = YES ;
    
    _lb_type.layer.cornerRadius = CORNER_RADIUS_ALL ;
    _lb_type.backgroundColor = [UIColor colorWithWhite:0 alpha:0.35] ;
    _lb_type.layer.borderWidth = ONE_PIXEL_VALUE ;
    _lb_type.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.1].CGColor ;
    _lb_type.layer.masksToBounds = YES ;
}

- (void)setupBarrageView
{
    if (!m_barrageView)
    {
        CGRect rectBarrage = CGRectMake(0, 0, APPFRAME.size.width, APPFRAME.size.width) ;
        
        m_barrageView = [[XTBarrageView alloc] initWithFrame:rectBarrage] ;
        m_barrageView.backgroundColor = nil ;
    }
    
    if (![m_barrageView superview])
    {
        [_img_big addSubview:m_barrageView];
    }
}

- (void)resetBarrageFrame
{
    CGRect rectBarrage = CGRectZero ;

    if (_multiSuperView.hidden)
    {
        // single
        rectBarrage = CGRectMake(0, 0, APPFRAME.size.width, APPFRAME.size.width) ;
    }
    else
    {
        // multiple
        rectBarrage.origin = CGPointMake(0, _multiSuperView.frame.size.height) ;
        rectBarrage.size.width = APPFRAME.size.width ;
        rectBarrage.size.height = APPFRAME.size.width - _multiSuperView.frame.size.height ;
    }
    
    m_barrageView.frame = rectBarrage ;
}

#pragma mark --
#pragma mark - setter
- (void)setArticle:(Article *)article
{
    _article = article ;
    
    //
    _article.delegate = self ;

    //img
    [_img_big sd_setImageWithURL:[NSURL URLWithString:_article.img] placeholderImage:IMG_NOPIC] ;
    
    //like
    _bt_likeOrNot.selected = _article.has_praised ;
    
    //comt count like count
    _lb_commentCount_likeCout.attributedText = [_article getAttributeStrCmtCountRplyCount];
    
    //comment content
    _lb_comment.attributedText = [_article getAttributeStrCommentContent];
    
    //flyword
    [m_barrageView setDataArray:_article.articleCommentList];
    
    if (_isflywordShow) [m_barrageView start] ;
    
    //multiple
    _multiSuperView.hidden = ![_article isMultyStyle] ;
    [self resetBarrageFrame] ;
    if (_multiSuperView.hidden) return ;
    
    _lb_title.text = article.a_title ;
    
    _lb_type.hidden = (!article.ac_content || ![article.ac_content length]) ;
    _lb_type.text = article.ac_content ;
    _lb_type.textColor = [Acategory getCateColorWithCateString:article.ac_content] ;
    
    ArticleTopic *topic = [article.articleTopicList firstObject] ;
    _img_tag_suEx.hidden = (topic.t_cate != t_cate_type_suExperience) ;
    
}

- (void)setIsflywordShow:(BOOL)isflywordShow
{
    _isflywordShow = isflywordShow ;
    
    isflywordShow ? [m_barrageView start] : [m_barrageView stop] ;
}

- (IBAction)likePressedAction:(id)sender
{
    if (!G_TOKEN || !G_USER.u_id)
    {
        [self.delegate goToLogin] ;
        return ;
    }
    
    _bt_likeOrNot.selected = !_bt_likeOrNot.selected ;
    
    [ServerRequest praiseThisArticle:_article.a_id AndWithBool:_bt_likeOrNot.selected Success:^(id json) {
        ResultParsered *result = [[ResultParsered alloc] initWithDic:json] ;
        NSLog(@"message : %@",result.message) ;
        
        [self getNewPraiseAndRefreshCollection] ;
        
    } fail:^{}] ;
    
}

- (void)getNewPraiseAndRefreshCollection
{
    [ServerRequest getPraisedInfoWithArticleID:_article.a_id AndWithSinceID:0 AndWithMaxID:0 AndWithCount:15 Success:^(id json) {

        ResultParsered *result = [[ResultParsered alloc] initWithDic:json] ;
        _article.praiseCount = [[result.info objectForKey:@"article_praise_count"] intValue] ;

        _lb_commentCount_likeCout.attributedText = [_article getAttributeStrCmtCountRplyCount];
        
    } fail:^{}] ;
}

- (CGSize)sizeThatFits:(CGSize)size
{
    NSString *strAttriComment = [_article getStrCommentContent] ;
    return CGSizeMake(size.width, [[self class] calculateHomeCellHeight:strAttriComment]) ;
}

+ (CGFloat)calculateHomeCellHeight:(NSString *)content
{
    CGFloat orgLbHeight = 25.0 ;
    UIFont *font = [UIFont systemFontOfSize:16.0f];
    CGSize size = CGSizeMake(APPFRAME.size.width - 13.0 * 2, 300);
    CGSize labelsize = [content boundingRectWithSize:size
                                             options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                          attributes:@{NSFontAttributeName:font}
                                             context:nil].size ;
    CGFloat lbHeight = labelsize.height ;
    if (lbHeight < orgLbHeight)
    {
        lbHeight = orgLbHeight ;
    }
    if (UNDER_IOS_VERSION(7.1)) // < 7.1
    {
        lbHeight += 5.0 ;
    }
    CGFloat h =  80.0f + APPFRAME.size.width - orgLbHeight + lbHeight ;
    return h ;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
