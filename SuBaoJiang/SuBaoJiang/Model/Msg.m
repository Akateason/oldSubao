//
//  Msg.m
//  SuBaoJiang
//
//  Created by apple on 15/6/16.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "Msg.h"
#import "User.h"


@implementation Msg

- (instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self)
    {
        _user = [[User alloc] initWithDic:dic] ;

        _msg_id = [[dic objectForKey:@"msg_id"] intValue] ;
        _msg_status = [[dic objectForKey:@"msg_status"] intValue] ;
        _img = [dic objectForKey:@"img"] ;
        _msg_content = [dic objectForKey:@"msg_content"] ;
        _a_id = [[dic objectForKey:@"a_id"] intValue] ;
        
        if (![[dic objectForKey:@"c_id"] isKindOfClass:[NSNull class]]) {
            _c_id = [[dic objectForKey:@"c_id"] intValue] ;
        }
        
        _msg_sendtime = [[dic objectForKey:@"msg_sendtime"] longLongValue] ;
        
        _a_parent_id = [[dic objectForKey:@"a_parent_id"] intValue] ;
        if (_a_parent_id != 0)
        {
            _a_id = _a_parent_id ;
        }
        
        
        _msg_skipType = [[dic objectForKey:@"msg_skip_type"] intValue] ;
        _msg_value = [dic objectForKey:@"msg_value"] ;
    }
    return self;
}

@end
