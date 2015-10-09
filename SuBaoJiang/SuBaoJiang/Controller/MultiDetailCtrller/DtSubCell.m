//
//  DtSubCell.m
//  subao
//
//  Created by apple on 15/8/12.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "DtSubCell.h"
#import "Article.h"
#import "UIImageView+WebCache.h"
#import "XTBarrageView.h"
#import "CommonFunc.h"
#import "DetailAttributes.h"

#define IMG_ORIGINAL_HEITHT     180.0f

@interface DtSubCell ()
//UIs
@property (weak, nonatomic) IBOutlet UIView             *bg_SubTitle;
@property (weak, nonatomic) IBOutlet UILabel            *lb_subTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topFlex_imgView;
@property (weak, nonatomic) IBOutlet UIImageView        *imgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height_imageView;
//Attrs
@property (strong, nonatomic)        XTBarrageView      *barrageView ;
@property (nonatomic,strong)         UIButton           *btSelect ;
@end

@implementation DtSubCell

#pragma mark --
#pragma mark - switch fly word
- (void)startOrCloseFlyword:(BOOL)bSwitch
{
    bSwitch ? [self.barrageView start] : [self.barrageView stop] ;
}

#pragma mark --
#pragma mark - Prop
- (UIButton *)btSelect
{
    if (!_btSelect)
    {
        _btSelect = [[UIButton alloc] init] ;
        _btSelect.frame = self.imgView.frame ;
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
    [self.delegate selectedTheImageWithAritcleID:self.subArticle.a_id] ;
}

- (XTBarrageView *)barrageView
{
    if (!_barrageView)
    {
        _barrageView = [[XTBarrageView alloc] initWithFrame:CGRectMake(0, 0, APPFRAME.size.width, self.imgView.frame.size.height)] ;
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

- (void)setSubArticle:(Article *)subArticle
{
    _subArticle = subArticle ;
    
    // @OPTIONAL: subArticle title
    BOOL hasSubTitle = !( !subArticle.a_title || [subArticle.a_title isEqualToString:@""] ) ;
    _bg_SubTitle.hidden = !hasSubTitle ;
    _topFlex_imgView.constant = hasSubTitle ? 53.0f : 1.0f ;
    _lb_subTitle.text = subArticle.a_title ;
    
    // @REQUERED: image view .
    if (subArticle.isUploaded)
    {
        [_imgView sd_setImageWithURL:[NSURL URLWithString:subArticle.img]
                           completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                               
                               if (cacheType == SDImageCacheTypeNone && !error)
                               {
                                   [self.delegate imgDownloadFinished] ;
                               }
                               
                               CGFloat resultImgHeight = 200 ; // defaultHeight
                               if (image != nil)
                               {
                                   // down load finished , will fixing new size of this imageView .
                                   resultImgHeight = image.size.height * APPFRAME.size.width / image.size.width ;
                                   _height_imageView.constant = resultImgHeight ;
                               }
                               
                               if (error)
                               {
                                   NSLog(@"error : %@",error) ;
                                   _imgView.image = nil ;
                               }
                               
                               CGRect barrageRect = CGRectZero ;
                               barrageRect.size.width = APPFRAME.size.width ;
                               barrageRect.size.height = resultImgHeight ;
                               self.barrageView.frame = barrageRect ;
                               self.btSelect.frame = barrageRect ;
                               
                           }] ;
    }
    else
    {
        _imgView.image = (!subArticle.realImage) ? nil : subArticle.realImage ;
        CGFloat resultImgHeight = subArticle.realImage.size.height * APPFRAME.size.width / subArticle.realImage.size.width ;
        _height_imageView.constant = resultImgHeight ;
    }
    
    // @OPTIONAL: subArticle content
    _lb_subContent.hidden = !subArticle.a_content || [subArticle.a_content isEqualToString:@""] ;
   
    NSString *labelString = subArticle.a_content;
    NSString *myString = [labelString stringByReplacingOccurrencesOfString:@"\r\n" withString:@"\n"] ;
    _lb_subContent.text = myString ;

    
    //flyword
    [self.barrageView setDataArray:subArticle.articleCommentList];
    if (_isflywordShow) [self.barrageView start] ;
}

+ (CGFloat)calculateHeightWithArticle:(Article *)subArticle
{
    // get image view height
    CGFloat imgHeight = IMG_ORIGINAL_HEITHT ;
    
    if (subArticle.isUploaded)
    {
        UIImage *cacheImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:subArticle.img
                                                                         withCacheWidth:APPFRAME.size.width] ;
        CGFloat cacheImgWidth = !cacheImage.size.width ? APPFRAME.size.width : cacheImage.size.width ;
        imgHeight = (!cacheImage) ? imgHeight : APPFRAME.size.width * cacheImage.size.height / cacheImgWidth ;
    }
    else
    {
        imgHeight = APPFRAME.size.width * subArticle.realImage.size.height / subArticle.realImage.size.width ;
    }
    
    // get title height
    BOOL hasSubTitle = !( !subArticle.a_title || [subArticle.a_title isEqualToString:@""] ) ;
    CGFloat titleHeight = hasSubTitle ? 53.0f : 1.0f ;
    
    // get content height
    BOOL hasSubContent = !( !subArticle.a_content || [subArticle.a_content isEqualToString:@""] ) ;
    
    CGFloat lbHeight = [XTlineSpaceLabel getAttributedStringHeightWidthValue:APPFRAME.size.width - 14.0 * 2 content:subArticle.a_content attributes:[DetailAttributes attributesWithLineSpace:7.0]] ;
    
    if (lbHeight < 17.0)
    {
        lbHeight = 17.0 ;
    }
    CGFloat contentHeight = hasSubContent ? lbHeight + 18.0 * 2 : 0.0f ;
    
    return imgHeight + titleHeight + contentHeight ;
}

- (void)dealloc
{
    [self startOrCloseFlyword:NO] ;
    self.barrageView = nil ;
}

- (void)awakeFromNib
{
    // Initialization code
    _imgView.userInteractionEnabled = YES ;
    _imgView.contentMode = UIViewContentModeScaleAspectFit ;
    _imgView.backgroundColor = COLOR_BACKGROUND ;
    
    [self longpressInitial] ;
    [self barrageView] ;
    [self btSelect] ;
}

- (void)longpressInitial
{
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongpress:)] ;
    lpgr.minimumPressDuration = 1.0f ;
    [self addGestureRecognizer:lpgr] ;
}

- (void)handleLongpress:(UILongPressGestureRecognizer *)longPressRecognizer
{
    if (longPressRecognizer.state != UIGestureRecognizerStateBegan) return ; // except multiple pressed it !
    
    [self.delegate longPressedCallback:self.subArticle] ;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
