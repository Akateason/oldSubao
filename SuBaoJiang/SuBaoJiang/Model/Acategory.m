//
//  Acategory.m
//  SuBaoJiang
//
//  Created by apple on 15/6/12.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "Acategory.h"
#import "ArticleTopic.h"
#import "UIColor+HexString.h"
#import "DigitInformation.h"

@implementation Acategory

- (instancetype)initWithDic:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        _ac_id = [[dict objectForKey:@"ac_id"] intValue] ;
        _ac_content = [dict objectForKey:@"ac_content"] ;
        _ac_img = [dict objectForKey:@"ac_img"] ;
        _ac_color = [dict objectForKey:@"ac_color"] ;
        
        if (![[dict objectForKey:@"topics"] isKindOfClass:[NSNull class]])
        {
            NSMutableArray *resultTopiclist = [NSMutableArray array] ;
            NSArray *tempList = [dict objectForKey:@"topics"] ;
            for (NSDictionary *tempDIc in tempList)
            {
                ArticleTopic *topic = [[ArticleTopic alloc] initWithDict:tempDIc] ;
                [resultTopiclist addObject:topic] ;
            }
            _topicList = resultTopiclist ;
        }
    }
    
    return self;
}

+ (UIColor *)getCateColorWithCateID:(int)cateID
{
    NSString *colorStr = @"" ;
    for (Acategory *acate in [DigitInformation shareInstance].cateColors)
    {
        if (acate.ac_id == cateID) {
            colorStr = acate.ac_color ;
            break ;
        }
    }
    
    return [UIColor colorWithHexString:colorStr] ;
}

+ (UIColor *)getCateColorWithCateString:(NSString *)acContent
{
    NSString *colorStr = nil ;
    for (Acategory *acate in [DigitInformation shareInstance].cateColors)
    {
        if ([acate.ac_content isEqualToString:acContent])
        {
            colorStr = acate.ac_color ;
            break ;
        }
    }
    
    if (!colorStr) {
        return [UIColor blackColor] ;
    }
    
    return [UIColor colorWithHexString:colorStr] ;
}

@end
