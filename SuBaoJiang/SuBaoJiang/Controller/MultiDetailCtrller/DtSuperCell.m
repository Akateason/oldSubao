//
//  DtSuperCell.m
//  subao
//
//  Created by apple on 15/8/12.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "DtSuperCell.h"
#import "UIImageView+WebCache.h"
#import "Article.h"
#import "KSBarrageView.h"

@interface DtSuperCell ()
@property (weak, nonatomic) IBOutlet UIImageView    *imgView;
@property (weak, nonatomic) IBOutlet UILabel        *lb_Content;
@property (strong, nonatomic)        KSBarrageView  *barrageView ;
@property (nonatomic,strong)         UIButton       *btSelect ;
@end

@implementation DtSuperCell

#pragma mark --
#pragma mark - switch fly word
- (void)startOrCloseFlyword:(BOOL)bSwitch
{
    bSwitch ? [self.barrageView start] : [self.barrageView stop] ;
}

#pragma mark - Properties
- (UIButton *)btSelect
{
    if (!_btSelect) {
        _btSelect = [[UIButton alloc] init] ;
        _btSelect.frame = CGRectMake(0, 0, APPFRAME.size.width, APPFRAME.size.width) ;
        _btSelect.backgroundColor = nil ;
        [_btSelect addTarget:self
                      action:@selector(imageSelectedAction)
            forControlEvents:UIControlEventTouchUpInside] ;
        if (![_btSelect superview]) {
            [self.imgView addSubview:_btSelect] ;
        }
    }
    
    return _btSelect ;
}

- (void)imageSelectedAction
{
    [self.delegate selectedTheImageWithAritcleID:self.article.a_id] ;
}

- (KSBarrageView *)barrageView
{
    if (!_barrageView)
    {
        _barrageView = [[KSBarrageView alloc] initWithFrame:CGRectMake(0, 0, APPFRAME.size.width, APPFRAME.size.width)] ;
        _barrageView.backgroundColor = nil ;
    }
    
    if (![_barrageView superview])
    {
        [self.imgView addSubview:_barrageView];
    }
    
    return _barrageView ;
}

- (void)setIsflywordShow:(BOOL)isflywordShow
{
    _isflywordShow = isflywordShow ;
    
    [self startOrCloseFlyword:isflywordShow] ;
}

- (void)setArticle:(Article *)article
{
    _article = article ;
    
    _lb_Content.text = article.a_content ;
    _lb_Content.hidden = ![article isMultyStyle] ;
    
    if (article.isUploaded) {
        [_imgView sd_setImageWithURL:[NSURL URLWithString:article.img]
                    placeholderImage:IMG_NOPIC] ;
    }
    else {
        _imgView.image = article.realImage ;
    }
    
    //flyword
    [self.barrageView setDataArray:article.articleCommentList];
    if (self.isflywordShow) [self.barrageView start] ;
}

- (void)dealloc
{
    [self startOrCloseFlyword:NO] ;
    
    self.barrageView = nil ;
}

- (void)awakeFromNib
{
    // Initialization code
    self.imgView.userInteractionEnabled = YES ;
    
    [self longpressRecognizer] ;
    //弹幕
    [self barrageView] ;
    //
    [self btSelect] ;
}

- (void)longpressRecognizer
{
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)] ;
    lpgr.minimumPressDuration = 1.0f ;
    [self addGestureRecognizer:lpgr] ;
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)longPressGesture
{
    if (longPressGesture.state != UIGestureRecognizerStateBegan) return ; // except multiple pressed it !
    
    [self.delegate longPressedCallback:self.article] ;
}

+ (CGFloat)calculateHeight:(Article *)article
{
    CGFloat imgHeight = APPFRAME.size.width ;
    
    UIFont *font = [UIFont systemFontOfSize:16.0f];
    CGSize size = CGSizeMake(APPFRAME.size.width - 14.0 * 2, 2000.0f);
    CGSize labelsize = [article.a_content
                        sizeWithFont:font
                        constrainedToSize:size
                        lineBreakMode:UILineBreakModeWordWrap];
    
    CGFloat lbHeight = labelsize.height ;
    
    if (lbHeight < 17.0)
    {
        lbHeight = 17.0 ;
    }
    
    CGFloat h = ![article isMultyStyle] ? imgHeight : lbHeight + 18.0 * 2 + imgHeight ;
    
    return h ;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
