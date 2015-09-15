//
//  SubaoCollectionCell.m
//  SuBaoJiang
//
//  Created by apple on 15/6/15.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "SubaoCollectionCell.h"
#import "UIImageView+WebCache.h"

@interface SubaoCollectionCell ()
@property (weak, nonatomic) IBOutlet UIImageView *img_big;
@property (weak, nonatomic) IBOutlet UILabel *lb_cmt;
@property (weak, nonatomic) IBOutlet UIImageView *imgDraft;
@end


@implementation SubaoCollectionCell

- (void)setArticle:(Article *)article
{
    _article = article ;
    
    // 已上传
    if (article.isUploaded)
    {
        [_img_big sd_setImageWithURL:[NSURL URLWithString:_article.img] placeholderImage:IMG_NOPIC] ;
        
        if (![article.a_title length])
        {
            _lb_cmt.text = (!_article.a_content || [_article.a_content isEqualToString:@""]) ? WD_NONE_CONTENT : _article.a_content ;
        }
        else
        {
            _lb_cmt.text = article.a_title ;
        }
    }
    // 草稿 (多图)
    else
    {
        _img_big.image = article.realImage ;
        _lb_cmt.text = (![article.a_title length] || !article.a_title) ? WD_NONE_CONTENT : article.a_title ;
    }
    
    _imgDraft.hidden = article.isUploaded ;
}

- (void)awakeFromNib
{
    // Initialization code
    _imgDraft.hidden = YES ;
    self.backgroundColor = [UIColor whiteColor] ;
    _img_big.contentMode = UIViewContentModeScaleAspectFit ;
}

@end
