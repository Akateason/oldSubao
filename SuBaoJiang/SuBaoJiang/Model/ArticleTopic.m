//
//  ArticleTopic.m
//  SuBaoJiang
//
//  Created by apple on 15/6/5.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "ArticleTopic.h"
#import "XTTickConvert.h"

@implementation ArticleTopic

- (SEMC_ShowType)showSEMC_Type
{
    if (!_showSEMC_Type)
    {
        if (self.t_cate == t_cate_type_suExperience) {
            _showSEMC_Type = SEMC_ShowType_suExperience ;
        }
        else {
            if (self.is_hot) {
                _showSEMC_Type = SEMC_ShowType_hot ;
            }
            else {
                _showSEMC_Type = SEMC_ShowType_default ;
            }
        }
    }
    
    return _showSEMC_Type ;
}

- (instancetype)initEmptyTopicWithContent:(NSString *)str
{
    self = [super init];
    if (self) {
        _t_id = 0 ;
        _t_content = str ;
    }
    return self;
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self)
    {
        _t_id = [[dict objectForKey:@"t_id"] intValue] ;
        _t_content = [dict objectForKey:@"t_content"] ;
        
        _t_img = [dict objectForKey:@"t_img"] ;
        _tr_count = [[dict objectForKey:@"tr_count"] intValue] ;
        _is_hot = [[dict objectForKey:@"is_hot"] boolValue] ;
        _t_cate = [[dict objectForKey:@"t_cate"] integerValue] ;
        
        _t_createtime = [[dict objectForKey:@"t_createtime"] longLongValue] ;
        _t_begintime = [[dict objectForKey:@"t_begintime"] longLongValue] ;
        _t_endtime = [[dict objectForKey:@"t_endtime"] longLongValue] ;
        
        _t_detail = [dict objectForKey:@"t_detail"] ;
    }
    return self;
}

+ (NSArray *)getTopicListWithDictList:(NSArray *)tempTopicList
{
    NSMutableArray *resultTopicList = [NSMutableArray array] ;
    
    for (NSDictionary *topicDict in tempTopicList)
    {
        ArticleTopic *aTopic = [[ArticleTopic alloc] initWithDict:topicDict] ;
        [resultTopicList addObject:aTopic] ;
    }
    
    return resultTopicList ;
}

- (UIImage *)getShowTypeImageWithSemcOrTopic:(BOOL)semcOrTopic
{
    UIImage *imgType = nil ;
    switch (self.showSEMC_Type)
    {
        case SEMC_ShowType_default:
        {
            imgType = nil ;
        }
            break;
        case SEMC_ShowType_suExperience:
        {
            imgType = semcOrTopic ? [UIImage imageNamed:@"semc_se"] : [UIImage imageNamed:@"topic_su"];
        }
            break;
        case SEMC_ShowType_hot:
        {
            imgType = semcOrTopic ? [UIImage imageNamed:@"semc_hot"] : [UIImage imageNamed:@"topic_hot"]  ;
        }
            break;
        default:
            break;
    }
    
    return imgType ;
}

- (NSString *)getTopicDetailString
{
    NSString *strContentWillShow = @"" ;
    if (self.t_cate == t_cate_type_suExperience)
    {
        long long now = [XTTickConvert getTickWithDate:[NSDate date]] ;
        if (now < self.t_begintime) {
            strContentWillShow = @"即将开始" ;
        } else if (now > self.t_endtime) {
            strContentWillShow = @"已开奖" ;
        } else {
            strContentWillShow = [[XTTickConvert getDateWithTick:self.t_endtime AndWithFormart:TIME_STR_FORMAT_7] stringByAppendingString:@"截止"] ;
        }
    }
    else
    {
        strContentWillShow = [NSString stringWithFormat:@"已有%d条相关内容",self.tr_count] ;
    }
    return strContentWillShow ;
}

- (UIImage *)getTopicTimeImage
{
    UIImage *imgResult = nil ;
    if (self.t_cate == t_cate_type_suExperience)
    {
        long long now = [XTTickConvert getTickWithDate:[NSDate date]] ;
        if (now < self.t_begintime) {
            imgResult = [UIImage imageNamed:@"topicStatus_willStart"] ;
        } else if (now > self.t_endtime) {
            imgResult = [UIImage imageNamed:@"topicStatus_end"] ;
        } else {
            imgResult = [UIImage imageNamed:@"topicStatus_ing"] ;
        }
    }
    else
    {
        imgResult = nil ;
    }

    return imgResult ;
}

@end
