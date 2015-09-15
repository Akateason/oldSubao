//
//  TopicCell.m
//  SuBaoJiang
//
//  Created by apple on 15/6/12.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "TopicCell.h"
#import "ArticleTopic.h"
#import "UIImageView+WebCache.h"

@interface TopicCell ()
@property (weak, nonatomic) IBOutlet UIImageView *img_topic;
@property (weak, nonatomic) IBOutlet UILabel *lb_topic;
@property (weak, nonatomic) IBOutlet UILabel *lb_content;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *flex_lb_topic_left;

@property (weak, nonatomic) IBOutlet UIImageView *img_topicType;
@property (weak, nonatomic) IBOutlet UIImageView *img_su_timeStatus;

@property (nonatomic)       BOOL    hiddenImgs ;
@end

@implementation TopicCell

- (void)awakeFromNib
{
    // Initialization code
    
    _img_topic.layer.borderWidth = ONE_PIXEL_VALUE ;
    _img_topic.layer.borderColor = COLOR_BORDER_GRAY.CGColor ;
    _img_topic.layer.cornerRadius = 6.0 ;
    _img_topic.layer.masksToBounds = YES ;
    _img_topic.contentMode = UIViewContentModeScaleAspectFit ;
}

- (void)setHiddenImgs:(BOOL)hiddenImgs
{
    _img_su_timeStatus.hidden = hiddenImgs ;
    _img_topicType.hidden = hiddenImgs ;
    _flex_lb_topic_left.constant = hiddenImgs ? 16.0f : 41.0f ;
}

- (void)setTopic:(ArticleTopic *)topic
{
    _topic = topic ;
    
    if (!topic.t_id)
    {
        self.hiddenImgs = YES ;
        
        _img_topic.image = [UIImage imageNamed:@"topicDefault"] ;
        _lb_topic.text = [NSString stringWithFormat:@"#%@#",topic.t_content] ;
        _lb_content.text = @"创建新话题" ;
    }
    else
    {
        self.hiddenImgs = ( ( topic.t_cate == t_cate_type_default ) && ( topic.is_hot == NO ) ) ;
        
        [_img_topic sd_setImageWithURL:[NSURL URLWithString:topic.t_img]
                      placeholderImage:IMG_NOPIC] ;
        _lb_topic.text = [NSString stringWithFormat:@"#%@#",topic.t_content] ;
        _lb_content.text = [topic getTopicDetailString] ;
        _img_topicType.image = [topic getShowTypeImageWithSemcOrTopic:NO] ;
        _img_su_timeStatus.image = [topic getTopicTimeImage] ;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
