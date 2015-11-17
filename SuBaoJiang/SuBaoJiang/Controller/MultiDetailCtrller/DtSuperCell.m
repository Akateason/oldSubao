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
#import "XTBarrageView.h"
#import "XTlineSpaceLabel.h"
#import "DetailAttributes.h"

@interface DtSuperCell ()
@property (weak, nonatomic) IBOutlet UIImageView            *imgView ;
@property (weak, nonatomic) IBOutlet XTlineSpaceLabel       *lb_Content ;
@property (strong, nonatomic)        XTBarrageView          *barrageView ;
@property (nonatomic,strong)         UIButton               *btSelect ;
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

- (XTBarrageView *)barrageView
{
    if (!_barrageView)
    {
        _barrageView = [[XTBarrageView alloc] initWithFrame:CGRectMake(0, 0, APPFRAME.size.width, APPFRAME.size.width)] ;
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
                    placeholderImage:IMG_NOPIC
                           completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){}] ;
    }
    else {
        _imgView.image = article.realImage ;
    }
    
}

- (void)setAllCommentsList:(NSArray *)allCommentsList
{
    _allCommentsList = allCommentsList ;
    
    //flyword
    [self.barrageView setDataArray:allCommentsList];
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
    _lb_Content.text = @"" ;
    
    self.imgView.userInteractionEnabled = YES ;
    //
    [self longpressRecognizer] ;
    //
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
    
    CGFloat lbHeight = [XTlineSpaceLabel getAttributedStringHeightWidthValue:APPFRAME.size.width - 14.0 * 2 content:article.a_content attributes:[DetailAttributes attributesWithLineSpace:7.0]] ;
    
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
