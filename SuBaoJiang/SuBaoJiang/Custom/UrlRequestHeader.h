//
//  UrlRequestHeader.h
//  SuBaoJiang
//
//  Created by apple on 15/6/4.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#ifndef SuBaoJiang_UrlRequestHeader_h
#define SuBaoJiang_UrlRequestHeader_h

/**
 *服务器ip地址切换
 *API1:version1.0
 *API2:version1.01
 *API3:version1.1-1.20.1
 */
#define G_IP_SERVER             @"http://api3.subaojiang.com/"

//审核开关
#define URL_CHECK_SWITCH        @"login/version_switch"

//举报
#define URL_REPORT              @"index/report_article"

//发布
#define URL_UPLOAD_ARTICLE      @"Index/upload"
#define URL_UPLOAD_MULTY        @"Index/uploadmulti"


//获取骑牛token
#define URL_QINIU_TOKEN         @"Index/get_qiniu_token"

//话题搜索
#define URL_SEARCH_TOPIC        @"search/topics"

//贴纸
#define URL_PASTER_ALL          @"sticker/index"

//首页
#define URL_HOMEPAGE_GETINFO    @"index/public_timeline_by_time"

//获取话题颜色
#define URL_CATE_COLOR          @"index/get_category_color"

//获取文章详情
#define URL_ARTICLE_DETAIL      @"index/show_article_total"

//删除发布的文章
#define URL_ARTICLE_DELETE      @"index/destroy"

//获取文章点赞集合
#define URL_DETAIL_PRAISE       @"index/show_detail_praise"

//获取文章评论
#define URL_GET_COMMENT         @"index/show_detail_comment"

//发布文章评论
#define URL_CREATE_COMMENT      @"comments/create"

//回复评论
#define URL_COMMENT_REPLY       @"comments/reply"

//删除评论
#define URL_COMMENT_DELETE      @"comments/destroy"


//点赞
#define URL_PRAISE_CREATE       @"praise/create"
//取消赞
#define URL_PRAISE_DELETE       @"praise/destroy"

//获取话题list
#define URL_GET_TOPICLIST       @"topic/index"

//获取话题文章
#define URL_ART_WITH_TOPIC      @"topic/detail"

//获取话题页——话题分类列表（话题分类，内容分类）
#define URL_TOPIC_CATE          @"topic/get_by_topic_cate"

//更新个人信息
#define URL_UPDATE_PERSON_INFO  @"personal/update_userinfo"
//获取我的主页 个人信息
#define URL_PERSONAL_INFO       @"personal/info"
//获取我的主页 我的速报
#define URL_PERSONAL_SUBAO      @"personal/home_timeline"
//获取我的主页 我的评论
#define URL_PERSONAL_COMMENT    @"personal/comment_by_me"
//获取我的主页 我的赞过
#define URL_PERSONAL_PRAISED    @"personal/praise_by_me"


//获取他人主页
#define URL_OTHER_HOMEPAGE      @"user/homepage"


//获取消息_评论
#define URL_MSG_COMMENT         @"message/comment_msg"
//获取消息_赞
#define URL_MSG_PRAISE          @"message/praise_msg"
//获取消息_系统
#define URL_MSG_SYSTEM          @"message/system_msg"

//更新消息状态 已读
#define URL_MSG_READ            @"message/read_msg"

//获取未读消息数量
#define URL_MSG_COUNT           @"message/count_msg"


//联合登陆
#define URL_LOGIN_UNION         @"login/index"
//注册
#define URL_LOGIN_REGISTER      @"login/register"


//设置--意见反馈
#define URL_SETTING_OPINION     @"set/suggest"

#endif
