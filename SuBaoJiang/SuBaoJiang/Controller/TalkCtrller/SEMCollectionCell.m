//
//  SEMCollectionCell.m
//  SuBaoJiang
//
//  Created by TuTu on 15/7/29.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "SEMCollectionCell.h"
#import "UIImageView+WebCache.h"
#import "ArticleTopic.h"
#import "XTTickConvert.h"

@interface SEMCollectionCell ()
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UIImageView *img_topicType;
@property (weak, nonatomic) IBOutlet UILabel *lb_topicContent;
@property (weak, nonatomic) IBOutlet UILabel *lb_status;
@property (weak, nonatomic) IBOutlet UIImageView *img_status;
@end

@implementation SEMCollectionCell

- (void)setTopic:(ArticleTopic *)topic
{
    _topic = topic ;
    
    // img base
    [_img sd_setImageWithURL:[NSURL URLWithString:topic.t_img] placeholderImage:IMG_NOPIC] ;
    // img up
    _img_topicType.image = [topic getShowTypeImageWithSemcOrTopic:YES] ;
    // topic content
    _lb_topicContent.text = [NSString stringWithFormat:@"#%@#",topic.t_content] ;
    _lb_topicContent.textColor = (topic.t_cate == t_cate_type_suExperience) ? COLOR_SEMC_GREEN : COLOR_SEMC_RED ;
    // lb status detail
    _lb_status.textColor = COLOR_GRAY_CONTENT ;
    _img_status.hidden = !(topic.t_cate == t_cate_type_suExperience) ;
    _img_status.image = [topic getTopicTimeImage] ;
    _lb_status.text = [topic getTopicDetailString] ;

}

- (void)awakeFromNib
{
    // Initialization code
    self.backgroundColor        = [UIColor whiteColor] ;
    _img.contentMode            = UIViewContentModeScaleAspectFit ;
    _img_topicType.contentMode  = UIViewContentModeScaleAspectFit ;

}

@end
