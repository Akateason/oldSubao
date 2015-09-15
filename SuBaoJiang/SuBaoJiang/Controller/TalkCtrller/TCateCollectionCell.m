//
//  TCateCollectionCell.m
//  SuBaoJiang
//
//  Created by TuTu on 15/7/30.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "TCateCollectionCell.h"
#import "ArticleTopic.h" 
#import "UIImageView+WebCache.h"

@interface TCateCollectionCell ()
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UIImageView *img_type;
@property (weak, nonatomic) IBOutlet UILabel *lb_content;
@end

@implementation TCateCollectionCell

- (void)awakeFromNib
{
    // Initialization code
    self.backgroundColor = [UIColor whiteColor] ;
    _img_type.layer.borderColor     = COLOR_BORDER_GRAY.CGColor ;
    _img_type.layer.borderWidth     = 0.5f ;
    _img.layer.cornerRadius         = CORNER_RADIUS_ALL ;
    _img_type.layer.cornerRadius    = CORNER_RADIUS_ALL ;
    _img.layer.masksToBounds        = YES ;
    _img_type.layer.masksToBounds   = YES ;
}

- (void)setTopic:(ArticleTopic *)topic
{
    _topic = topic ;
    
    [_img sd_setImageWithURL:[NSURL URLWithString:topic.t_img]
            placeholderImage:IMG_NOPIC] ;
    _img_type.image = [topic getShowTypeImageWithSemcOrTopic:YES] ;
    
    _lb_content.text = [NSString stringWithFormat:@"#%@#",topic.t_content] ;
}

@end
