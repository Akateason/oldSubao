//
//  MESubArticleCell.h
//  subao
//
//  Created by apple on 15/8/21.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMMoveTableViewCell.h"
#import "Article.h"

typedef NS_ENUM(NSInteger, TypeOfSubArticleQueueSection)
{
    type_normal = 0 ,   // default
    type_head ,         // first line
    type_tail           // last  line
} ;

@protocol MESubArticleCellDelegate <NSObject>
- (void)subArticleTitleTextViewBecomeFirstResponder:(int)row ;
- (void)subArticleContentTextviewPressed:(int)sub_CLient_A_ID ;
- (void)subTitleChanged:(NSString *)title client_aID:(int)sub_CLient_A_ID ;
- (void)changeImage:(int)sub_CLient_A_ID ;
- (void)editImage:(int)sub_CLient_A_ID ;
- (void)deleteThisSubArticle:(int)sub_CLient_A_ID ;
- (void)insertSubArticleBelowRow:(int)row ;
- (void)moveUpFromRow:(int)row ;
- (void)moveDownFromRow:(int)row ;
@end

@interface MESubArticleCell : FMMoveTableViewCell
@property (nonatomic,strong) id <MESubArticleCellDelegate> delegate ;
@property (nonatomic)        int                           row ; // row in cell indexpath.row
@property (nonatomic)        TypeOfSubArticleQueueSection  queueType ; // ctrl UIs of moving Bts
@property (nonatomic,strong) Article                       *subArticle ;
@end
