//
//  DtOperationCell.h
//  subao
//
//  Created by apple on 15/8/13.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Article ;
@class ArticleTopic ;

@protocol DtOperationCellDelegate <NSObject>
// 标签点击
- (void)topicSelected:(ArticleTopic *)topic ;
// 去登陆
- (void)goToLogin ;
// 更多点赞人
- (void)moreLikersPressedWithArticleID:(int)articleID ;
// 分享
- (void)clickShareCallBack ;
// 删除
- (void)deleteMyArticle ;
// 举报
- (void)reportCallBack ;
// 点击用户头
- (void)clickUserHead:(int)userID ;
// 已经点赞
- (void)hasPraised:(BOOL)hasPraised ;
@end

@interface DtOperationCell : UITableViewCell

@property (nonatomic,weak) id <DtOperationCellDelegate> delegate ;
@property (nonatomic,strong) Article *superArticle ;
- (void)getNewPraiseWithisLiked:(BOOL)isLiked ;

@end
