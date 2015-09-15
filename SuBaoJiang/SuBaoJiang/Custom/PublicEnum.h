//
//  PublicEnum.h
//  subao
//
//  Created by apple on 15/9/14.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#ifndef subao_PublicEnum_h
#define subao_PublicEnum_h

/*
 页面跳转. (系统通知,首页banner)
 **/
typedef enum
{
    mode_advertise = 1, //广告 h5
    mode_activity ,     //活动 h5
    mode_topic ,        //话题 t_id
    mode_detail         //详情 a_id
} MODE_skipCategory ;

/**
 category
 用户分类，1为微信，2为微博，3为用户名密码登录
 */
typedef enum {
    mode_WeiXin = 1 ,
    mode_WeiBo  ,
    mode_Local
} MODE_LOGIN_CATE ;

/**
 举报类型，1为文章，2为用户
 */
typedef enum {
    mode_Article = 1 ,
    mode_User  ,
} MODE_TYPE_REPORT ;

/**
 消息类型，1为评论消息，2为赞，3为系统消息
 */
typedef enum {
    mode_cmt = 1 ,
    mode_praise ,
    mode_sys
} MODE_NOTE ;

/**
 用户中心 , segment
 */
typedef enum
{
    mode_MY_SUBAO ,
    mode_MY_COMMENT ,
    mode_MY_PRAISED
} MODE_SEG_SEL ;


#endif
