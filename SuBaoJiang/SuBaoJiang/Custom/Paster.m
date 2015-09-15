//
//  Paster.m
//  subao
//
//  Created by apple on 15/9/14.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "Paster.h"

@implementation Paster

- (instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        _name = [dic objectForKey:@"sti_name"] ;
        _url = [dic objectForKey:@"sti_url"] ;
    }
    return self;
}

@end
