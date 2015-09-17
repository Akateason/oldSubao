//
//  ServerRequest.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-12.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "ServerRequest.h"
#import "XTRequest.h"
#import "UrlRequestHeader.h"
#import "DigitInformation.h"

#import "SBJson.h"
#import "ASIFormDataRequest.h"
#import "ASIHTTPRequest.h"
#import "CommonFunc.h"

@implementation ServerRequest

//privace
+ (NSString *)getFinalUrl:(NSString *)urlstr
{
    NSString *str = [G_IP_SERVER stringByAppendingString:urlstr] ;
    return [self appendTokenWithUrl:str] ;
}

+ (NSString *)appendTokenWithUrl:(NSString *)url
{
    NSString *urltoken = [G_TOKEN length] ? [NSString stringWithFormat:@"?token=%@",G_TOKEN] : @"?token=0";
    return [url stringByAppendingString:urltoken] ;
}

/**
 @paramer : bToken 是否要传token
 */
+ (NSMutableDictionary *)getParameters
{
    return [NSMutableDictionary dictionary] ;
}

+ (NSString *)getToken
{
    return [G_TOKEN length] ? G_TOKEN : @"0" ;
}

#pragma mark -- 审核开关
/**
 请求参数	是否必须	说明
 version	选填参数	当前版本号
 */
+ (ResultParsered *)getCheckSwitchWithCurrentAppVersion:(NSString *)versionCurrent
{
    NSMutableDictionary *paramer = [self getParameters] ;
    [paramer setObject:versionCurrent forKey:@"version"] ;
    return [self getJsonWithURLstr:[self getFinalUrl:URL_CHECK_SWITCH] AndWithParamer:paramer AndWithMode:GET_MODE] ;
}


#pragma mark -- 微博用户信息
+ (NSDictionary *)getWeiboUserInfoWithToken:(NSString *)weiboToken
                                 AndWithUid:(NSString *)uid
{
    NSString *str = [NSString stringWithFormat:@"https://api.weibo.com/2/users/show.json?access_token=%@&uid=%@&source=%@",weiboToken,uid,WB_APPKEY];
    NSURL *url = [NSURL URLWithString:str];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    NSError *error;
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    NSString *jsonStr = [[NSString alloc] initWithData:received encoding:NSUTF8StringEncoding];
    
    NSLog(@"weibo jsonStr:%@",jsonStr);
    
    SBJsonParser *parser = [[SBJsonParser alloc] init] ;
    NSDictionary *dictionary = [parser objectWithString:jsonStr] ;
    
    return dictionary ;
}


#pragma mark -- 举报
/**
 请求参数	是否必须	说明
 r_type	必填参数	举报类型，1为文章，2为用户
 r_content	必填参数	举报内容，文章id或者用户id
 */
+ (void)reportWithType:(MODE_TYPE_REPORT)modeReport
             contentID:(int)aidOrUid
               success:(void (^)(id json))success
                  fail:(void (^)())fail
{
    NSMutableDictionary *paramer = [self getParameters] ;
    [paramer setObject:[NSNumber numberWithInt:(int)modeReport]
                forKey:@"r_type"] ;
    [paramer setObject:[NSNumber numberWithInt:aidOrUid]
                forKey:@"r_content"] ;
    
    [XTRequest POSTWithUrl:[self getFinalUrl:URL_REPORT] parameters:paramer success:^(id json) {
        if (success) success(json);
    } fail:^{
        if (fail) fail();
    }] ;
}



// public
#pragma mark - 发布
/** 发布一条图文信息
 请求参数	是否必须	说明
 a_content	选填参数	信息文字内容
 img	必填参数	信息图片地址（七牛云存储地址）
 topic	选填参数	信息关联话题文字（如 ＃话题＃）
 */
+ (void)uploadArticle:(NSString *)articleContent
                image:(NSString *)imagePath
                topic:(NSString *)topicContent
              success:(void (^)(id json))success
                 fail:(void (^)())fail
{
    NSMutableDictionary *paramer = [self getParameters] ;

    if (articleContent) {
        [paramer setObject:articleContent
                    forKey:@"a_content"] ;
    }
    
    [paramer setObject:imagePath
                forKey:@"img"] ;
    
    if (topicContent) {
        [paramer setObject:topicContent
                    forKey:@"topic"] ;
    }
    
    [XTRequest POSTWithUrl:[self getFinalUrl:URL_UPLOAD_ARTICLE] parameters:paramer success:^(id json) {
        if (success) success(json);
    } fail:^{
        if (fail) fail();
    }] ;
}

/** 发布多图测试
 请求参数	是否必须	说明
 a_content	选填参数	信息文字内容
 img	必填参数	信息图片地址（七牛云存储地址）
 topic	选填参数	信息关联话题文字（如 ＃话题＃）
 a_title	选填参数	标题（多图必填）
 child_item	选填参数	字文章JSON（包含a_content,img,a_title,a_link,a_location字段，其中a_link和a_location为备用字段，传空字符串’‘）
 */
+ (void)uploadArticleWithContent:(NSString *)content
                           image:(NSString *)image
                           topic:(NSString *)topic
                           title:(NSString *)title
                      childsItem:(NSString *)jsonStr
                         success:(void (^)(id json))success
                            fail:(void (^)())fail
{
    NSMutableDictionary *paramer = [self getParameters] ;
    [paramer setObject:content  forKey:@"a_content"] ;
    [paramer setObject:image    forKey:@"img"] ;
    [paramer setObject:topic    forKey:@"topic"] ;
    [paramer setObject:title    forKey:@"a_title"] ;
    [paramer setObject:jsonStr  forKey:@"child_item"] ;
    
    [XTRequest POSTWithUrl:[self getFinalUrl:URL_UPLOAD_MULTY] parameters:paramer success:^(id json) {
        if (success) success(json);
    } fail:^{
        if (fail) fail();
    }] ;
}


/** 取七牛token
 bucket	必填参数	存储空间
 */
+ (void)getQiniuTokenWithBuckect:(NSString *)bucket
                         success:(void (^)(id json))success
                            fail:(void (^)())fail
{
    NSMutableDictionary *paramer = [self getParameters] ;
    [paramer setObject:bucket forKey:@"bucket"] ;
    
    [XTRequest GETWithUrl:[self getFinalUrl:URL_QINIU_TOKEN] parameters:paramer success:^(id json) {
        if (success) success(json);
    } fail:^{
        if (fail) fail();
    }] ;
}

+ (ResultParsered *)getQiniuTokenWithBuckect:(NSString *)bucket
{
    NSMutableDictionary *paramer = [self getParameters] ;
    [paramer setObject:bucket forKey:@"bucket"] ;

    return [self getJsonWithURLstr:[self getFinalUrl:URL_QINIU_TOKEN] AndWithParamer:paramer AndWithMode:GET_MODE] ;
}




/** 话题搜索
 请求参数	是否必须	说明
 t_content	选填参数	检索话题关键词
 page	选填参数	当前显示页码
 count	选填参数	每页显示数量
 */
+ (void)searchTalkListWithContent:(NSString *)t_content
                             page:(int)page
                            count:(int)count
                          success:(void (^) (id json))success
                             fail:(void (^)())fail
{
    NSMutableDictionary *paramer = [self getParameters] ;
    [paramer setObject:t_content
                forKey:@"t_content"] ;
    [paramer setObject:[NSNumber numberWithInt:page]
                forKey:@"page"] ;
    [paramer setObject:[NSNumber numberWithInt:count]
                forKey:@"count"] ;
    
    [XTRequest GETWithUrl:[self getFinalUrl:URL_SEARCH_TOPIC] parameters:paramer success:^(id json) {
        if (success) success(json);
    } fail:^{
        if (fail) fail();
    }] ;
    
}

#pragma mark -- 贴纸
/**
 请求参数	是否必须	说明
 is_all	选填参数	是否不按分类获取所有贴纸
 */
+ (ResultParsered *)getAllPasters
{
    NSMutableDictionary *paramer = [self getParameters] ;
    [paramer setObject:@1 forKey:@"is_all"] ;
    
    return [self getJsonWithURLstr:[self getFinalUrl:URL_PASTER_ALL]
                    AndWithParamer:paramer
                       AndWithMode:GET_MODE] ;
}

#pragma mark - 首页
/** 标签颜色
 */
+ (ResultParsered *)getCateTypeColor
{
    return [self getJsonWithURLstr:[self getFinalUrl:URL_CATE_COLOR]
                    AndWithParamer:nil
                       AndWithMode:GET_MODE] ;
}

/** 获取首页
 since_id	选填参数	若指定此参数，则返回ID比since_id大的评论（即比since_id时间晚的评论），默认为0
 max_id     选填参数	若指定此参数，则返回ID小于或等于max_id的评论，默认为0。
 count      选填参数	单页返回的记录条数，默认为50。
 */
+ (ResultParsered *)getHomePageInfoResultWithSinceID:(int)sinceID
                                            AndMaxID:(long long)maxID
                                            AndCount:(int)count
{
    NSMutableDictionary *paramer = [self getParameters] ;
    
    [paramer setObject:[NSNumber numberWithLongLong:maxID]
                forKey:@"max_id"] ;
    [paramer setObject:[NSNumber numberWithInt:sinceID]
                forKey:@"since_id"] ;
    [paramer setObject:[NSNumber numberWithInt:count]
                forKey:@"count"] ;
    
    return [self getJsonWithURLstr:[self getFinalUrl:URL_HOMEPAGE_GETINFO] AndWithParamer:paramer AndWithMode:GET_MODE] ;    
}



/** 获取文章详情
 a_id  文章id
 */
+ (ResultParsered *)getArticleDetailWithArticleID:(int)a_id
{
    NSMutableDictionary *paramer = [self getParameters] ;
    [paramer setObject:[NSNumber numberWithInt:a_id]   forKey:@"a_id"] ;

    return [self getJsonWithURLstr:[self getFinalUrl:URL_ARTICLE_DETAIL] AndWithParamer:paramer AndWithMode:GET_MODE] ;
}

+ (void)getArticleDetailWithArticleID:(int)a_id
                              Success:(void (^)(id json))success
                                 fail:(void (^)())fail
{
    NSMutableDictionary *paramer = [self getParameters] ;
    [paramer setObject:[NSNumber numberWithInt:a_id]   forKey:@"a_id"] ;

    [XTRequest GETWithUrl:[self getFinalUrl:URL_ARTICLE_DETAIL] parameters:paramer success:^(id json) {
        if (success) success(json);
    } fail:^{
        if (fail) fail();
    }] ;
}

/**
 删除发布的文章信息  index/destroy
 a_id	必填参数	删除文章ID
 */
+ (void)deleteMyArticleWithA_id:(int)a_id
                        success:(void(^)(id json))success
                           fail:(void(^)())fail
{
    NSMutableDictionary *paramer = [self getParameters] ;
    [paramer setObject:[NSNumber numberWithInt:a_id]   forKey:@"a_id"] ;
    
    [XTRequest POSTWithUrl:[self getFinalUrl:URL_ARTICLE_DELETE] parameters:paramer success:^(id json) {
        if (success) success(json);
    } fail:^{
        if (fail) fail();
    }] ;
}


/** 文章信息_赞的人数
 请求参数	是否必须	说明
 a_id	必填参数	文章id
 page	选填参数	分页当前页码，默认为1
 count	选填参数	单页返回的记录条数，默认为50。
 */
+ (ResultParsered *)getPraisedInfoWithArticleID:(int)a_id
                                 AndWithSinceID:(int)sinceID
                                   AndWithMaxID:(int)maxID
                                   AndWithCount:(int)count
{
    NSMutableDictionary *paramer = [self getParameters] ;
    [paramer setObject:[NSNumber numberWithInt:a_id]    forKey:@"a_id"] ;
    [paramer setObject:[NSNumber numberWithInt:sinceID] forKey:@"since_id"] ;
    [paramer setObject:[NSNumber numberWithInt:maxID]   forKey:@"max_id"] ;
    [paramer setObject:[NSNumber numberWithInt:count]   forKey:@"count"] ;
    
    return [self getJsonWithURLstr:[self getFinalUrl:URL_DETAIL_PRAISE] AndWithParamer:paramer AndWithMode:GET_MODE] ;
}

+ (void)getPraisedInfoWithArticleID:(int)a_id
                     AndWithSinceID:(int)sinceID
                       AndWithMaxID:(int)maxID
                       AndWithCount:(int)count
                            Success:(void (^)(id json))success
                               fail:(void (^)())fail
{
    NSMutableDictionary *paramer = [self getParameters] ;
    [paramer setObject:[NSNumber numberWithInt:a_id]    forKey:@"a_id"] ;
    [paramer setObject:[NSNumber numberWithInt:sinceID] forKey:@"since_id"] ;
    [paramer setObject:[NSNumber numberWithInt:maxID]   forKey:@"max_id"] ;
    [paramer setObject:[NSNumber numberWithInt:count]   forKey:@"count"] ;
    
    [XTRequest GETWithUrl:[self getFinalUrl:URL_DETAIL_PRAISE] parameters:paramer success:^(id json) {
        if (success) success(json);
    } fail:^{
        if (fail) fail();
    }] ;
}


/** 文章详情_评论信息
 请求参数	是否必须	说明
 a_id	必填参数	文章id
 page	选填参数	分页当前页码，默认为1
 since_id	选填参数	若指定此参数，则返回ID比since_id大的评论（即比since_id时间晚的评论），默认为0
 max_id	选填参数	若指定此参数，则返回ID小于或等于max_id的评论，默认为0。
 count	选填参数	单页返回的记录条数，默认为50。
 */
+ (ResultParsered *)getCommentWithArticleID:(int)a_id
                             AndWithSinceID:(int)sinceID
                               AndWithMaxID:(int)maxID
                               AndWithCount:(int)count
{
    NSMutableDictionary *paramer = [self getParameters] ;
    [paramer setObject:[NSNumber numberWithInt:a_id]    forKey:@"a_id"] ;
    [paramer setObject:[NSNumber numberWithInt:sinceID] forKey:@"since_id"] ;
    [paramer setObject:[NSNumber numberWithInt:maxID]   forKey:@"max_id"] ;
    [paramer setObject:[NSNumber numberWithInt:count]   forKey:@"count"] ;
    
    return [self getJsonWithURLstr:[self getFinalUrl:URL_GET_COMMENT] AndWithParamer:paramer AndWithMode:GET_MODE] ;
}

/** 为一条文章添加评论
 c_content	必填参数	评论内容
 a_id	必填参数	评论文章id
 color	必填参数	评论颜色
 size	必填参数	评论文字大小
 position	必填参数	评论显示位置
 */
+ (void)createCommentsForArticle:(int)articleID
                  AndWithContent:(NSString *)content
                    AndWithColor:(NSString *)color
                     AndWithSize:(NSString *)size
                 AndWithPosition:(NSString *)position
                         Success:(void (^)(id json))success
                            fail:(void (^)())fail
{
    NSMutableDictionary *paramer = [self getParameters] ;
    [paramer setObject:[NSNumber numberWithInt:articleID]    forKey:@"a_id"] ;
    [paramer setObject:content      forKey:@"c_content"] ;
    [paramer setObject:color        forKey:@"color"] ;
    [paramer setObject:size         forKey:@"size"] ;
    [paramer setObject:position     forKey:@"position"] ;
    
    [XTRequest POSTWithUrl:[self getFinalUrl:URL_CREATE_COMMENT] parameters:paramer success:^(id json) {
        if (success) success(json);
    } fail:^{
        if (fail) fail();
    }] ;
}

+ (ResultParsered *)createCommentsForArticle:(int)articleID
                              AndWithContent:(NSString *)content
                                AndWithColor:(NSString *)color
                                 AndWithSize:(NSString *)size
                             AndWithPosition:(NSString *)position
{
    NSMutableDictionary *paramer = [self getParameters] ;
    [paramer setObject:[NSNumber numberWithInt:articleID]    forKey:@"a_id"] ;
    [paramer setObject:content      forKey:@"c_content"] ;
    [paramer setObject:color        forKey:@"color"] ;
    [paramer setObject:size         forKey:@"size"] ;
    [paramer setObject:position     forKey:@"position"] ;
    
    return [self getJsonWithURLstr:[self getFinalUrl:URL_CREATE_COMMENT] AndWithParamer:paramer AndWithMode:POST_MODE] ;
}


/** 回复一条评论
 c_content	必填参数	评论内容
 reply_id	必填参数	回复评论的id
 color	必填参数	评论颜色
 size	必填参数	评论文字大小
 position	必填参数	评论显示位置
 */
+ (void)replyCommetWithCmtID:(int)cmtID
              AndWithContent:(NSString *)content
                AndWithColor:(NSString *)color
                 AndWithSize:(NSString *)size
             AndWithPosition:(NSString *)position
                     Success:(void (^)(id json))success
                        fail:(void (^)())fail
{
    NSMutableDictionary *paramer = [self getParameters] ;
    [paramer setObject:[NSNumber numberWithInt:cmtID]    forKey:@"reply_id"] ;
    [paramer setObject:content      forKey:@"c_content"] ;
    [paramer setObject:color        forKey:@"color"] ;
    [paramer setObject:size         forKey:@"size"] ;
    [paramer setObject:position     forKey:@"position"] ;

    
    [XTRequest POSTWithUrl:[self getFinalUrl:URL_COMMENT_REPLY] parameters:paramer success:^(id json) {
        if (success) success(json);
    } fail:^{
        if (fail) fail();
    }] ;

}


+ (ResultParsered *)replyCommetWithCmtID:(int)cmtID
                          AndWithContent:(NSString *)content
                            AndWithColor:(NSString *)color
                             AndWithSize:(NSString *)size
                         AndWithPosition:(NSString *)position
{
    NSMutableDictionary *paramer = [self getParameters] ;
    [paramer setObject:[NSNumber numberWithInt:cmtID]    forKey:@"reply_id"] ;
    [paramer setObject:content      forKey:@"c_content"] ;
    [paramer setObject:color        forKey:@"color"] ;
    [paramer setObject:size         forKey:@"size"] ;
    [paramer setObject:position     forKey:@"position"] ;
    
    return [self getJsonWithURLstr:[self getFinalUrl:URL_COMMENT_REPLY] AndWithParamer:paramer AndWithMode:POST_MODE] ;
}


/** 删除一条评论
 c_id	必填参数	评论ID
 */
+ (void)deleteMyCmt:(int)cmtID
            Success:(void (^)(id json))success
               fail:(void (^)())fail
{
    NSMutableDictionary *paramer = [self getParameters] ;
    [paramer setObject:[NSNumber numberWithInt:cmtID] forKey:@"c_id"] ;

    [XTRequest POSTWithUrl:[self getFinalUrl:URL_COMMENT_DELETE] parameters:paramer success:^(id json) {
        if (success) success(json);
    } fail:^{
        if (fail) fail();
    }] ;
}


#pragma mark --
/** 点赞
 请求参数	是否必须	说明
 a_id	必填参数	点赞文章ID
 */
+ (void)praiseThisArticle:(int)articleID
              AndWithBool:(BOOL)bCreateOrDelete
                  Success:(void (^)(id json))success
                     fail:(void (^)())fail
{
    NSMutableDictionary *paramer = [self getParameters] ;
    [paramer setObject:[NSNumber numberWithInt:articleID] forKey:@"a_id"] ;
    
    NSString *urlStr = bCreateOrDelete ? [self getFinalUrl:URL_PRAISE_CREATE] : [self getFinalUrl:URL_PRAISE_DELETE] ;
    [XTRequest POSTWithUrl:urlStr parameters:paramer success:^(id json) {
        if (success) success(json);
    } fail:^{
        if (fail) fail();
    }] ;
}

#pragma mark -- 话题
/**话题页_话题列表和分类
 t_cate	选填参数	话题分类，0为所有话题，1为速体验，默认为0
 page	选填参数	当前显示页码
 count	选填参数	每页显示数量
 */
+ (ResultParsered *)getAllTopicListAndCataWithCate:(int)t_cate
                                              page:(int)page
                                             count:(int)count
{
    NSMutableDictionary *paramer = [self getParameters] ;
    [paramer setObject:[NSNumber numberWithInt:t_cate]
                forKey:@"t_cate"] ;
    [paramer setObject:[NSNumber numberWithInt:page]
                forKey:@"page"] ;
    [paramer setObject:[NSNumber numberWithInt:count]
                forKey:@"count"] ;
    
    return [self getJsonWithURLstr:[self getFinalUrl:URL_GET_TOPICLIST] AndWithParamer:paramer AndWithMode:GET_MODE] ;
}


/**话题详情
 参数	是否必须	说明
 t_id	必填参数	话题ID
 page	选填参数	分页当前页码，默认为1
 since_id	选填参数	若指定此参数，则返回ID比since_id大的评论（即比since_id时间晚的评论），默认为0
 max_id	选填参数	若指定此参数，则返回ID小于或等于max_id的评论，默认为0。
 count	选填参数	单页返回的记录条数，默认为50。
 */
+ (ResultParsered *)getArticleWithTopicID:(int)topicID
                           AndWithSinceID:(int)sinceID
                             AndWithMaxID:(long long)maxID
                             AndWithCount:(int)count
{
    NSMutableDictionary *paramer = [self getParameters] ;
    
    [paramer setObject:[NSNumber numberWithInt:topicID]
                forKey:@"t_id"] ;
    [paramer setObject:[NSNumber numberWithInt:sinceID]
                forKey:@"since_id"] ;
    [paramer setObject:[NSNumber numberWithLongLong:maxID]
                forKey:@"max_id"] ;
    [paramer setObject:[NSNumber numberWithInt:count]
                forKey:@"count"] ;
    
    return [self getJsonWithURLstr:[self getFinalUrl:URL_ART_WITH_TOPIC] AndWithParamer:paramer AndWithMode:GET_MODE] ;
}

/**话题_分类获取列表
 参数	是否必须	说明
 ac_id	选填参数	话题内容分类，不分类为0，默认为－1
 page	选填参数	当前显示页码
 count	选填参数	每页显示数量
 */
+ (ResultParsered *)getTopicByCate:(int)ac_id
                              page:(int)page
                             count:(int)count
{
    NSMutableDictionary *paramer = [self getParameters] ;
    
    [paramer setObject:[NSNumber numberWithInt:ac_id]
                forKey:@"ac_id"] ;
    [paramer setObject:[NSNumber numberWithInt:page]
                forKey:@"page"] ;
    [paramer setObject:[NSNumber numberWithInt:count]
                forKey:@"count"] ;
    
    return [self getJsonWithURLstr:[self getFinalUrl:URL_TOPIC_CATE] AndWithParamer:paramer AndWithMode:GET_MODE] ;

}


#pragma mark -- 我的主页
//获取我的主页个人信息
+ (ResultParsered *)getMyIndexPersonalInfo
{
    return [self getJsonWithURLstr:[self getFinalUrl:URL_PERSONAL_INFO] AndWithParamer:nil AndWithMode:GET_MODE] ;
}

//获取我的速报(照片)
+ (ResultParsered *)getMySuBaoAndWithSinceID:(int)sinceID
                                AndWithMaxID:(int)maxID
                                AndWithCount:(int)count
{
    NSMutableDictionary *paramer = [self getParameters] ;
    
    [paramer setObject:[NSNumber numberWithInt:sinceID]
                forKey:@"since_id"] ;
    [paramer setObject:[NSNumber numberWithInt:maxID]
                forKey:@"max_id"] ;
    [paramer setObject:[NSNumber numberWithInt:count]
                forKey:@"count"] ;

    return [self getJsonWithURLstr:[self getFinalUrl:URL_PERSONAL_SUBAO] AndWithParamer:paramer AndWithMode:GET_MODE] ;
}

//获取我的主页我的评论
+ (ResultParsered *)getMyCommentWithSinceID:(int)sinceID
                               AndWithMaxID:(int)maxID
                               AndWithCount:(int)count
{
    NSMutableDictionary *paramer = [self getParameters] ;
    
    [paramer setObject:[NSNumber numberWithInt:sinceID]
                forKey:@"since_id"] ;
    [paramer setObject:[NSNumber numberWithInt:maxID]
                forKey:@"max_id"] ;
    [paramer setObject:[NSNumber numberWithInt:count]
                forKey:@"count"] ;
    
    return [self getJsonWithURLstr:[self getFinalUrl:URL_PERSONAL_COMMENT] AndWithParamer:paramer AndWithMode:GET_MODE] ;
}

//获取我的主页我的赞过
+ (ResultParsered *)getMyPraisedWithSinceID:(int)sinceID
                               AndWithMaxID:(int)maxID
                               AndWithCount:(int)count
{
    NSMutableDictionary *paramer = [self getParameters] ;
    
    [paramer setObject:[NSNumber numberWithInt:sinceID]
                forKey:@"since_id"] ;
    [paramer setObject:[NSNumber numberWithInt:maxID]
                forKey:@"max_id"] ;
    [paramer setObject:[NSNumber numberWithInt:count]
                forKey:@"count"] ;
    
    return [self getJsonWithURLstr:[self getFinalUrl:URL_PERSONAL_PRAISED] AndWithParamer:paramer AndWithMode:GET_MODE] ;
}

//获取他人主页
+ (ResultParsered *)getOtherHomePageWithUserID:(int)uid
                                  AndWithMaxID:(int)maxID
                                  AndWithCount:(int)count
{
    NSMutableDictionary *paramer = [self getParameters] ;
    [paramer setObject:[NSNumber numberWithInt:uid]
                forKey:@"u_id"] ;
    [paramer setObject:[NSNumber numberWithInt:maxID]
                forKey:@"max_id"] ;
    [paramer setObject:[NSNumber numberWithInt:count]
                forKey:@"count"] ;
    
    return [self getJsonWithURLstr:[self getFinalUrl:URL_OTHER_HOMEPAGE] AndWithParamer:paramer AndWithMode:GET_MODE] ;
}

#pragma mark -- 消息
//获取消息_评论
+ (ResultParsered *)getMsgCommentMaxID:(int)maxID
                                 count:(int)count
{
    NSMutableDictionary *paramer = [self getParameters] ;
    [paramer setObject:[NSNumber numberWithInt:maxID]
                forKey:@"max_id"] ;
    [paramer setObject:[NSNumber numberWithInt:count]
                forKey:@"count"] ;

    
    return [self getJsonWithURLstr:[self getFinalUrl:URL_MSG_COMMENT] AndWithParamer:paramer AndWithMode:GET_MODE] ;
}


//获取消息_赞
+ (ResultParsered *)getMsgPraiseMaxID:(int)maxID
                                Count:(int)count
{
    NSMutableDictionary *paramer = [self getParameters] ;
    [paramer setObject:[NSNumber numberWithInt:maxID]
                forKey:@"max_id"] ;
    [paramer setObject:[NSNumber numberWithInt:count]
                forKey:@"count"] ;
    
    return [self getJsonWithURLstr:[self getFinalUrl:URL_MSG_PRAISE] AndWithParamer:paramer AndWithMode:GET_MODE] ;
}

//获取消息_系统
+ (ResultParsered *)getMsgSystemMaxID:(int)maxID
                                Count:(int)count
{
    NSMutableDictionary *paramer = [self getParameters] ;
    [paramer setObject:[NSNumber numberWithInt:maxID]
                forKey:@"max_id"] ;
    [paramer setObject:[NSNumber numberWithInt:count]
                forKey:@"count"] ;
    
    return [self getJsonWithURLstr:[self getFinalUrl:URL_MSG_SYSTEM] AndWithParamer:paramer AndWithMode:GET_MODE] ;
}

/**
 更新消息状态, 已经读取
 msg_id	必填参数	消息id字符串，以逗号分隔，如：1,2
 msg_type	必填参数	消息类型，1为评论消息，2为赞，3为系统消息
 */
+ (void)readMsg:(NSArray *)msgIdList
        msgType:(MODE_NOTE)modeNote
        success:(void (^)(id json))success
           fail:(void (^)())fail
{
    NSMutableDictionary *paramer = [self getParameters] ;
    
    NSString *strMsgIDlist = [CommonFunc getCommaStringWithArray:msgIdList] ;
    [paramer setObject:strMsgIDlist forKey:@"msg_id"] ;
    
    [paramer setObject:[NSNumber numberWithInt:modeNote] forKey:@"msg_type"] ;
    
    NSString *urlStr = [self getFinalUrl:URL_MSG_READ] ;
    [XTRequest POSTWithUrl:urlStr hud:NO parameters:paramer success:^(id json) {
        if (success) success(json);
    } fail:^{
        if (fail) fail();
    }] ;
}

//获取未读消息数量
+ (void)getNoReadMsgCountSuccess:(void (^)(id json))success
                            fail:(void (^)())fail
{
    NSMutableDictionary *paramer = [self getParameters] ;
    
    NSString *urlStr = [self getFinalUrl:URL_MSG_COUNT] ;
    
    [XTRequest POSTWithUrl:urlStr hud:NO parameters:paramer success:^(id json) {
        if (success) success(json);
    } fail:^{
        if (fail) fail();
    }] ;
    
}


#pragma mark -- 登陆注册
/**
 category	用户分类，1为微信，2为微博，3为用户名密码登录
 wxopenid	微信openid
 wxunionid	微信unionid
 nickname	昵称
 gender	性别
 language	语言
 country	国家
 province	省份
 city	城市
 headpic	头像
 wbuid	微博用户uid
 description	微博用户简介
 uuid	设备唯一标示符
 username| 用户登录账号
 password| 登录密码
 */
+ (ResultParsered *)loginUnitWithCategory:(MODE_LOGIN_CATE)cateMode
                                 wxopenID:(NSString *)wxopenid
                                wxUnionID:(NSString *)wxunionid
                                 nickName:(NSString *)nickname
                                   gender:(NSNumber *)gender
                                 language:(NSString *)language
                                  country:(NSString *)country
                                 province:(NSString *)province
                                     city:(NSString *)city
                                  headpic:(NSString *)headpic
                                    wbuid:(NSString *)wbuid
                              description:(NSString *)description
                                 username:(NSString *)username
                                 password:(NSString *)password
{
    NSString *uuid = [DigitInformation shareInstance].uuid ; // udid ;
    
    NSMutableDictionary *paramer = [self getParameters] ;
    
    [paramer setObject:[NSNumber numberWithInt:cateMode]
                forKey:@"category"] ;
    if (wxopenid) [paramer setObject:wxopenid forKey:@"wxopenid"] ;
    if (wxunionid) [paramer setObject:wxunionid forKey:@"wxunionid"] ;
    if (nickname) [paramer setObject:nickname forKey:@"nickname"] ;
    if (gender) [paramer setObject:gender forKey:@"gender"] ;
    if (language) [paramer setObject:language forKey:@"language"] ;
    if (country) [paramer setObject:country forKey:@"country"] ;
    if (province) [paramer setObject:province forKey:@"province"] ;
    if (city) [paramer setObject:city forKey:@"city"] ;
    if (headpic) [paramer setObject:headpic forKey:@"headpic"] ;
    if (wbuid) [paramer setObject:wbuid forKey:@"wbuid"] ;
    if (description) [paramer setObject:description forKey:@"description"] ;
    if (uuid) [paramer setObject:uuid forKey:@"uuid"] ;
    if (username) [paramer setObject:username forKey:@"username"] ;
    if (password) [paramer setObject:password forKey:@"password"] ;
    
    return [self getJsonWithURLstr:[self getFinalUrl:URL_LOGIN_UNION] AndWithParamer:paramer AndWithMode:POST_MODE] ;
}


+ (void)loginUnitWithCategory:(MODE_LOGIN_CATE)cateMode
                     wxopenID:(NSString *)wxopenid
                    wxUnionID:(NSString *)wxunionid
                     nickName:(NSString *)nickname
                       gender:(NSNumber *)gender
                     language:(NSString *)language
                      country:(NSString *)country
                     province:(NSString *)province
                         city:(NSString *)city
                      headpic:(NSString *)headpic
                        wbuid:(NSString *)wbuid
                  description:(NSString *)description
                     username:(NSString *)username
                     password:(NSString *)password
                      Success:(void (^)(id json))success
                         fail:(void (^)())fail
{
    NSString *uuid = [DigitInformation shareInstance].uuid ; // udid ;
    
    NSMutableDictionary *paramer = [self getParameters] ;
    
    [paramer setObject:[NSNumber numberWithInt:cateMode]
                forKey:@"category"] ;
    if (wxopenid) [paramer setObject:wxopenid forKey:@"wxopenid"] ;
    if (wxunionid) [paramer setObject:wxunionid forKey:@"wxunionid"] ;
    if (nickname) [paramer setObject:nickname forKey:@"nickname"] ;
    if (gender) [paramer setObject:gender forKey:@"gender"] ;
    if (language) [paramer setObject:language forKey:@"language"] ;
    if (country) [paramer setObject:country forKey:@"country"] ;
    if (province) [paramer setObject:province forKey:@"province"] ;
    if (city) [paramer setObject:city forKey:@"city"] ;
    if (headpic) [paramer setObject:headpic forKey:@"headpic"] ;
    if (wbuid) [paramer setObject:wbuid forKey:@"wbuid"] ;
    if (description) [paramer setObject:description forKey:@"description"] ;
    if (uuid) [paramer setObject:uuid forKey:@"uuid"] ;
    if (username) [paramer setObject:username forKey:@"username"] ;
    if (password) [paramer setObject:password forKey:@"password"] ;
   
    [XTRequest POSTWithUrl:[self getFinalUrl:URL_LOGIN_UNION] parameters:paramer success:^(id json) {
        if (success) success(json);
    } fail:^{
        if (fail) fail();
    }] ;
    
}

/**
 第三方注册
 username	必填参数	用户名
 password	必填参数	密码
 */
+ (void)loginRegisterUsername:(NSString *)username
                     password:(NSString *)password
                      Success:(void (^)(id json))success
                         fail:(void (^)())fail
{
    NSMutableDictionary *paramer = [self getParameters] ;
    
    [paramer setObject:username
                forKey:@"username"] ;
    [paramer setObject:password
                forKey:@"password"] ;
    
    [XTRequest POSTWithUrl:[self getFinalUrl:URL_LOGIN_REGISTER] parameters:paramer success:^(id json) {
        if (success) success(json);
    } fail:^{
        if (fail) fail();
    }] ;

}


#pragma mark -- 设置
/**
 设置--意见反馈
 */
+ (void)settingOpinionContent:(NSString *)content
                      success:(void (^) (id json))success
                         fail:(void (^) ())fail
{
    NSMutableDictionary *paramer = [self getParameters] ;
    [paramer setObject:content forKey:@"us_content"] ;
    
    [XTRequest POSTWithUrl:[self getFinalUrl:URL_SETTING_OPINION] parameters:paramer success:^(id json) {
        if (success) {
            success (json) ;
        }
    } fail:^{
        if (fail) {
            fail () ;
        }
    }] ;
}

@end
