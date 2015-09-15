//
//  DraftTB.h
//  subao
//
//  Created by apple on 15/8/21.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "FMDatabaseAdditions.h"
#import "DigitInformation.h"
@class Article ;

@interface DraftTB : NSObject
+ (DraftTB *)shareInstance ;
- (BOOL)creatTable ;
- (int)getMaxID ;
- (BOOL)insertArticleInDraft:(Article *)article ;
- (BOOL)updateArticleInDraft:(Article *)article ;
- (BOOL)deleteArticleWithCid:(int)cid ;
- (BOOL)uploadedArticleWithCid:(int)cid ;
- (NSMutableArray *)getAllNotUploadedSuperArticles ;
- (NSMutableArray *)getSubArticlesWithSuperArticleCLientID:(int)clientID ;
- (Article *)getSuperArticleWithCLientID:(int)clientID ;
- (BOOL)ExistNotUploadArticle ;
- (BOOL)ExistThisArticle:(int)cid ;
@end
