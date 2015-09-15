//
//  Msg.h
//  SuBaoJiang
//
//  Created by apple on 15/6/16.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PublicEnum.h"

/*
u_headpic       文章作者头像
u_nickname      文章作者昵称
u_id            点赞者id
img             点赞文章图片
msg_id          消息id
msg_content     消息文字
msg_status      消息状态，0为未读，1为已读
msg_sendtime	消息发送时间
*/

@class User ;

@interface Msg : NSObject

@property (nonatomic)        int                msg_id ;
@property (nonatomic)        int                msg_status ;
@property (nonatomic)        long long          msg_sendtime ;
@property (nonatomic,copy)   NSString           *msg_content ;
@property (nonatomic,copy)   NSString           *img ;
@property (nonatomic)        int                a_id ;
@property (nonatomic)        int                c_id ;
@property (nonatomic)        int                a_parent_id ;
@property (nonatomic,strong) User               *user ;

/*
 msg_type                         msg_value
 mode_advertise = 1, //广告 h5     urlStr
 mode_activity ,     //活动 h5     urlStr
 mode_topic ,        //话题 t_id   int
 mode_detail         //详情 a_id   int
**/
@property (nonatomic)        MODE_skipCategory  msg_skipType ;
@property (nonatomic,copy)   NSString           *msg_value ;

- (instancetype)initWithDic:(NSDictionary *)dic ;

@end
