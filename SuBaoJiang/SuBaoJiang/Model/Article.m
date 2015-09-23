//
//  Article.m
//  SuBaoJiang
//
//  Created by apple on 15/6/5.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "Article.h"
#import "ArticleTopic.h"
#import "ArticleComment.h"
#import "ArticlePraise.h"
#import "User.h"
#import "DigitInformation.h"
#import "XTTickConvert.h"
#import "UIImage+AddFunction.h"
#import <CoreText/CoreText.h>
#import "NSString+WPAttributedMarkup.h"
#import "WPAttributedStyleAction.h"
#import "WPHotspotLabel.h"
#import "XTFileManager.h"



@implementation Article

- (void)dealloc
{
    self.userCurrent = nil ;
    self.articleTopicList = nil ;
    self.praiseList = nil ;
    self.childList = nil ;
    self.realImage = nil ;
}

+ (NSString *)getPathInLocal:(NSString *)realImagePath
{
    return [NSString stringWithFormat:@"%@/%@",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject], [NSString stringWithFormat:@"%@.jpg",realImagePath]] ;
}

- (UIImage *)realImage
{
    if (!_realImage)
    {
        NSString *path = [[self class] getPathInLocal:self.realImagePath] ;
        _realImage = [[UIImage alloc] initWithContentsOfFile:path];
    }
    
    return _realImage ;
}

- (void)deleteRealImageInLocal
{
    NSString *path = [[self class] getPathInLocal:self.realImagePath] ;
    [XTFileManager deleteFileWithFileName:path] ;
}

- (instancetype)initWithArticleID:(int)a_id
                           ImgStr:(NSString *)imgStr
                          content:(NSString *)content
                     topicContent:(NSString *)topic
                            title:(NSString *)title
                       createTime:(long long )tick
{
    self = [super init] ;
    
    if (self)
    {
        _a_id = a_id ;
        _img = imgStr ;
        _a_content = (!content) ? @"" : content ;
        _a_createtime = tick ;
        _a_updatetime = _a_createtime ;
        if (topic)
        {
            ArticleTopic *topicTemp = [[ArticleTopic alloc] init] ;
            topicTemp.t_content = topic ;
            _articleTopicList = @[topicTemp] ;
        }
        _userCurrent = G_USER ;
        _a_title = title ;
    
        _isUploaded = YES ;
    }
    
    return self;
}



// init article cache in client .
- (instancetype)initArtWithClientID:(int)client_A_id
               superClientArticleID:(int)super_client_Aid
                         createTime:(long long)createTime
                        realpicPath:(NSString *)picPath
                            content:(NSString *)content
                              title:(NSString *)title
                           topicStr:(NSString *)topic
{
    self = [super init] ;
    
    if (self)
    {
        _a_id = 0 ; // server id is null
        _client_AID = client_A_id ;
        _super_client_AID = super_client_Aid ;
        
        _realImagePath = picPath ;
        
        _a_content = (!content) ? @"" : content ;
        _a_createtime = createTime ;
        _a_updatetime = _a_createtime ;

        _a_title = (!title) ? @"" : title ;
        
        if (topic)
        {
            ArticleTopic *topicTemp = [[ArticleTopic alloc] init] ;
            topicTemp.t_content = topic ;
            _articleTopicList = @[topicTemp] ;
        }
        
        _userCurrent = G_USER ;
        
        _isDeleted = NO ;
        _isUploaded = NO ;
    }
    
    return self ;
}

+ (NSString *)getPicPath:(long long)tick aid:(int)aid
{
    return [NSString stringWithFormat:@"%lld_%d_%d",tick,G_USER.u_id,aid] ;
}

- (void)cachePicInLocal:(UIImage *)picture tick:(long long)tick
{
    NSString *path = [[self class] getPathInLocal:[[self class] getPicPath:tick aid:self.client_AID]] ;
    
    picture = [UIImage compressQualityWithOriginImage:picture] ;
    picture = [picture imageCompressForSize:picture targetSize:CGSizeMake(640, 640)] ;
    
    [XTFileManager savingPicture:picture path:path] ;
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self)
    {
        _a_id = [[dict objectForKey:@"a_id"] intValue] ;
        _img = [dict objectForKey:@"img"] ;
        _a_content = [dict objectForKey:@"a_content"] ;
        _a_updatetime = [[dict objectForKey:@"a_updatetime"] longLongValue] ;
        _a_createtime = [[dict objectForKey:@"a_createtime"] longLongValue] ;
        
        _userCurrent = [[User alloc] initWithDic:dict] ;
        
        NSArray *tempTopicList = [dict objectForKey:@"article_topics"] ;
        _articleTopicList = [[ArticleTopic class] getTopicListWithDictList:tempTopicList] ;
        
        NSArray *tempCommentList = [dict objectForKey:@"article_comments"] ;
        _articleCommentList = [NSMutableArray arrayWithArray:[[ArticleComment class] getCommentListWithDictList:tempCommentList]] ;
        
        _article_comments_count = [[dict objectForKey:@"article_comments_count"] intValue] ;
        
        _has_praised = [[dict objectForKey:@"has_praised"] boolValue] ;
        
        _is_author = [[dict objectForKey:@"is_author"] boolValue] ;
        
        NSArray *tempPraiseList = [dict objectForKey:@"article_praise"] ;
        _praiseList = [[ArticlePraise class] getPraiseListWithDictList:tempPraiseList] ;

        _praiseCount = [[dict objectForKey:@"article_praise_count"] intValue] ;
        
        _a_title = [dict objectForKey:@"a_title"] ;
        _ac_content = [dict objectForKey:@"ac_content"] ;
        
        // child list if exist
        NSMutableArray *multiTemp = [NSMutableArray array] ;
        NSArray *tempChildList = [dict objectForKey:@"child_items"] ;
        for (NSDictionary *tempDic in tempChildList)
        {
            Article *artTemp = [[Article alloc] initWithDict:tempDic] ;
            [multiTemp addObject:artTemp] ;
        }
        _childList = multiTemp.count ? multiTemp : nil ;
        
        _isUploaded = YES ; // on server , this is important ! . i use this to
    }
    
    return self;
}


#pragma mark - public
- (NSDictionary *)getStyle
{
    __weak typeof(self) weakSelf = self ;
    
    return  @{
              @"body" : [UIFont systemFontOfSize:14.0f] ,
              @"content" : [UIFont systemFontOfSize:16.0f] ,
              @"light" : COLOR_HOME_LIGHT_WORDS ,
              @"dark" : COLOR_BLACK_DARK ,
              @"red"  : COLOR_MAIN ,
              @"darkRed" : COLOR_HOME_CMT_NUMBER ,
              @"topic" : [WPAttributedStyleAction styledActionWithAction:^{
                  NSLog(@"TOPIC CLICK !") ;
                  [weakSelf.delegate topicHotPotClicked] ;
              }] ,
              @"link" : COLOR_MAIN
            };
}

- (NSAttributedString *)getAttributeStrCmtCountRplyCount
{
//    NSString *strAttri = (!self.articleCommentList.count)
//    ? [NSString stringWithFormat:@"<darkRed>%d</darkRed><light> 人喜欢</light>",self.praiseCount]
//    : [NSString stringWithFormat:@"<darkRed>%lu</darkRed><light> 条评论</light> <darkRed>%d</darkRed><light> 人喜欢</light>",(unsigned long)self.articleCommentList.count,self.praiseCount] ;
    
    NSString *strAttri = (!self.article_comments_count)
    ? [NSString stringWithFormat:@"<darkRed>%d</darkRed><light> 人喜欢</light>",self.praiseCount]
    : [NSString stringWithFormat:@"<darkRed>%lu</darkRed><light> 条评论</light> <darkRed>%d</darkRed><light> 人喜欢</light>",(unsigned long)self.article_comments_count,self.praiseCount] ;
    
    return [strAttri attributedStringWithStyleBook:[self getStyle]] ;
}

- (NSAttributedString *)getAttributeStrCommentContent
{
    return [[self getStrCommentContentAttr] attributedStringWithStyleBook:[self getStyle]];
}

- (NSAttributedString *)getAttributeStrOnlyTopics
{
    return [[self getStrOnlyTopic] attributedStringWithStyleBook:[self getStyle]];
}

//privace
- (NSString *)getStrOnlyTopic
{
    NSString *strAttriComment = [[self getTopicStr] length] ? [NSString stringWithFormat:@"<topic>#%@#</topic>",[self getTopicStr]] : @"" ;
    
    return strAttriComment ;
}

- (NSString *)getStrCommentContentAttr
{
    NSString *strAttriComment = @"" ;
    if (!self.articleTopicList.count)
    {
        strAttriComment = [NSString stringWithFormat:@"<content><dark>%@</dark></content>",self.a_content];
    }
    else
    {
        strAttriComment = [NSString stringWithFormat:@"<content><topic>#%@#</topic><dark>%@</dark></content>",[self getTopicStr],self.a_content] ;
    }
    
    return strAttriComment ;
}

- (NSString *)getTopicStr
{
    return self.articleTopicList.count ? ((ArticleTopic *)[self.articleTopicList firstObject]).t_content : @"" ;
}

//public
- (NSString *)getStrCommentContent
{
    NSString *strAttriComment = @"" ;
    if (!self.articleTopicList.count) {
        strAttriComment = [NSString stringWithFormat:@"%@",self.a_content];
    } else {
        strAttriComment = [NSString stringWithFormat:@"#%@#%@",((ArticleTopic *)[self.articleTopicList firstObject]).t_content,self.a_content] ;
    }
    
    return strAttriComment ;
}

// is mult
- (BOOL)isMultyStyle
{
    return !([self.a_title isEqualToString:@""] || !self.a_title) ;
}

@end
