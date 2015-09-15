//
//  TopicCategory.m
//  SuBaoJiang
//
//  Created by TuTu on 15/7/29.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "TopicCategory.h"

@implementation TopicCategory
- (instancetype)initWithDic:(NSDictionary *)diction
{
    self = [super init];
    if (self) {
        self.ac_id = [[diction objectForKey:@"ac_id"] integerValue] ;
        self.ac_content = [diction objectForKey:@"ac_content"] ;
        self.ac_img = [diction objectForKey:@"ac_img"] ;
    }
    return self;
}
@end
