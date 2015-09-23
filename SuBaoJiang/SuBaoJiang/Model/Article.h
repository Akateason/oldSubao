//
//  Article.h
//  SuBaoJiang
//
//  Created by apple on 15/6/5.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ArticleTopic ;
@class User ;
@class ArticleComment ;
@class ArticlePraise ;


@protocol ArticleDelegate <NSObject>
- (void)topicHotPotClicked ;
@end

@interface Article : NSObject
@property (nonatomic,weak)    id <ArticleDelegate> delegate ;

@property (nonatomic)           int             a_id ;
@property (nonatomic,copy)      NSString        *img ;
@property (nonatomic,copy)      NSString        *a_content ;   //文章文字
@property (nonatomic)           long long       a_updatetime ; //审核通过,正式发布时间
@property (nonatomic)           long long       a_createtime ; //本地发布时间

@property (nonatomic,strong)    User            *userCurrent ;

@property (nonatomic,strong)    NSArray         *articleTopicList ; // 话题list

@property (nonatomic,strong)    NSMutableArray  *articleCommentList ; // 评论list
@property (nonatomic)           int             article_comments_count ; //总评论数

@property (nonatomic)           BOOL            has_praised	;  // 当前用户(我)是否点赞过

@property (nonatomic)           BOOL            is_author   ;  // 是否作者
@property (nonatomic,strong)    NSArray         *praiseList ;  // 点赞人list
@property (nonatomic)           int             praiseCount ;  // 点赞总数

@property (nonatomic,copy)      NSString        *a_title    ;       // 多图标题 (是多图才有)
@property (nonatomic,copy)      NSString        *ac_content ;       // 分类名称
@property (nonatomic,strong)    NSArray         *childList  ;       // 文章子集 (是多图才有)

@property (nonatomic)           int             client_AID  ;       // use in not exist.
@property (nonatomic)           int             super_client_AID ;  // in client ,superID, '==0' is superArticle , '> 0' is subArticle
@property (nonatomic)           BOOL            isDeleted   ;
@property (nonatomic)           BOOL            isUploaded  ;       // on server or not , jugdge how to show pictures .

@property (nonatomic,strong)    UIImage         *realImage ;        //real img .
@property (nonatomic,copy)      NSString        *realImagePath ;    //real img path .

- (instancetype)initWithDict:(NSDictionary *)dict ;

// init article uploaded to server
- (instancetype)initWithArticleID:(int)a_id
                           ImgStr:(NSString *)imgStr
                          content:(NSString *)content
                     topicContent:(NSString *)topic
                            title:(NSString *)title
                       createTime:(long long )tick ;

// init article cache in client .
// init article cache in client .
- (instancetype)initArtWithClientID:(int)client_A_id
               superClientArticleID:(int)super_client_Aid
                         createTime:(long long)createTime
                        realpicPath:(NSString *)picPath
                            content:(NSString *)content
                              title:(NSString *)title
                           topicStr:(NSString *)topic ;

+ (NSString *)getPathInLocal:(NSString *)realImagePath ;
+ (NSString *)getPicPath:(long long)tick aid:(int)aid ;
- (void)cachePicInLocal:(UIImage *)picture tick:(long long)tick ;

- (NSAttributedString *)getAttributeStrCmtCountRplyCount ;
- (NSAttributedString *)getAttributeStrOnlyTopics ;
- (NSAttributedString *)getAttributeStrCommentContent ; // "#topics#contents"

- (NSString *)getTopicStr ;
- (NSString *)getStrCommentContent ;

- (BOOL)isMultyStyle ;
- (void)deleteRealImageInLocal ;

@end
