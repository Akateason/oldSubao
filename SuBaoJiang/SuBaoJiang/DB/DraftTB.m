//
//  DraftTB.m
//  subao
//
//  Created by apple on 15/8/21.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "DraftTB.h"
#import "Article.h"

#define TABLENAME           @"DraftTB"

#define SQL_CREATETABLE     [NSString stringWithFormat:@"CREATE TABLE %@ ( cID INT NOT NULL PRIMARY KEY DEFAULT '0' , cSuperID INT NOT NULL DEFAULT '0' , createTime BIGINT DEFAULT '0' NOT NULL , userID INT NOT NULL DEFAULT '0' , title Nvarchar(128) NOT NULL DEFAULT '' , content Nvarchar(256) NOT NULL DEFAULT '' , picPath Nvarchar(256) NOT NULL DEFAULT '' , isDelete INT DEFAULT '0' NOT NULL , isUpload INT DEFAULT '0' NOT NULL , topic Nvarchar(64) NOT NULL DEFAULT '' )",TABLENAME]

#define SQL_INSERTTABLE     [NSString stringWithFormat:@"INSERT INTO %@ ( cID , cSuperID , createTime , userID , title , content , picPath , isDelete , isUpload , topic ) VALUES (?,?,?,?,?,?,?,?,?,?)",TABLENAME]

static DraftTB *instance ;

@implementation DraftTB

+ (DraftTB *)shareInstance
{
    if (!instance) {
        instance = [[[self class] alloc] init];
    }
    
    return instance ;
}

- (NSString *)databaseFilePath
{
    NSArray *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) ;
    NSString *documentPath = [filePath firstObject] ;
    NSString *dbFilePath = [documentPath stringByAppendingPathComponent:SQLITEPATH] ;

    return dbFilePath ;
}

- (void)creatDatabase
{
    @synchronized(DB) {
        DB = [FMDatabase databaseWithPath:[self databaseFilePath]];
    }
}

- (BOOL)creatTable
{
    @synchronized(DB) {
        BOOL b ;
        if (!DB) {
            [self creatDatabase];
        }
        if (![DB open]) {
            NSLog(@"database open is failed");
            return false ;
        }
        
        [DB setShouldCacheStatements:YES];
        
        if(![DB tableExists:TABLENAME])
        {
            b = [DB executeUpdate:SQL_CREATETABLE];
            if (b) NSLog(@"tb create finished");
            
            return b ;
        }
    }
    
    return NO ;
}

- (int)getMaxID
{
    @synchronized(DB)
    {
        if (!DB) {
            [self creatDatabase];
        }
        
        if (![DB open]) {
            NSLog(@"database open is failed");
            return 0;
        }
        
        if(![DB tableExists:TABLENAME])
        {
            return 0;
        }
        
        int _maxID = 0;
        FMResultSet *rs = [DB executeQuery:[NSString stringWithFormat:@"select max(cID) from %@",TABLENAME]];
        //判断结果集中是否有数据，如果有则取出数据
        while ([rs next]) {
            _maxID = [rs intForColumn:@"max(cID)"];
        }
        return _maxID ;
    }
}


- (BOOL)insertArticleInDraft:(Article *)article
{
    @synchronized(DB)
    {
        BOOL b = false ;
        if (!DB) [self creatDatabase];
        if (![DB open])
        {
            NSLog(@"database open is failed");
            return false;
        }
        
        [DB setShouldCacheStatements:YES];
        
        if(![DB tableExists:TABLENAME]) [self creatTable];
        
        b = [DB executeUpdate:SQL_INSERTTABLE,
             [NSString stringWithFormat:@"%d",article.client_AID] ,
             [NSString stringWithFormat:@"%d",article.super_client_AID] ,
             [NSString stringWithFormat:@"%lld",article.a_createtime] ,
             [NSString stringWithFormat:@"%d",article.userCurrent.u_id] ,
             article.a_title ,
             article.a_content ,
             article.realImagePath ,
             [NSString stringWithFormat:@"%d",article.isDeleted] ,
             [NSString stringWithFormat:@"%d",article.isUploaded] ,
             [article getTopicStr]
            ] ;
        
        return b ;
    }
    
    return false ;
}


- (BOOL)updateArticleInDraft:(Article *)article
{
    @synchronized(DB)
    {
        BOOL bResult = false ;
        if (!DB) [self creatDatabase] ;
        if (![DB open]) {
            NSLog(@"database open is failed");
            return false;
        }
        [DB setShouldCacheStatements:YES] ;
        if(![DB tableExists:TABLENAME]) [self creatTable] ;
        
        bResult = [DB executeUpdate:
                   [NSString stringWithFormat:@"UPDATE %@ SET title = '%@' , content = '%@' , topic = '%@'  WHERE cID = %d", TABLENAME , article.a_title , article.a_content , [article getTopicStr] , article.client_AID]
                   ] ;
        
        return bResult ;
    }
    
    return false ;
}

- (BOOL)deleteArticleWithCid:(int)cid
{
    @synchronized(DB)
    {
        BOOL bResult = false ;
        if (!DB) [self creatDatabase] ;
        if (![DB open]) {
            NSLog(@"database open is failed");
            return false;
        }
        [DB setShouldCacheStatements:YES] ;
        if(![DB tableExists:TABLENAME]) [self creatTable] ;
        
        bResult = [DB executeUpdate:
                    [NSString stringWithFormat:@"UPDATE %@ SET isDelete = 1 WHERE cID = %d", TABLENAME , cid]
                   ] ;
        
        return bResult ;
    }
    
    return false ;
}


- (BOOL)uploadedArticleWithCid:(int)cid
{
    @synchronized(DB)
    {
        BOOL bResult = false ;
        if (!DB) [self creatDatabase] ;
        if (![DB open]) {
            NSLog(@"database open is failed");
            return false;
        }
        [DB setShouldCacheStatements:YES] ;
        if(![DB tableExists:TABLENAME]) [self creatTable] ;
        
        bResult = [DB executeUpdate:
                   [NSString stringWithFormat:@"UPDATE %@ SET isUpload = 1 WHERE cID = %d", TABLENAME , cid]
                   ] ;
        
        return bResult ;
    }
    
    return false ;
}


- (NSMutableArray *)getAllNotUploadedSuperArticles
{
    @synchronized(DB)
    {
        if (!DB) [self creatDatabase];
        
        if (![DB open]) {
            NSLog(@"database open is failed");
            return nil;
        }
        
        [DB setShouldCacheStatements:YES];
        
        if(![DB tableExists:TABLENAME]) return nil;
        
        NSMutableArray *resultList = [[NSMutableArray alloc] initWithCapacity:1] ;
        
        FMResultSet *rs = [DB executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@ WHERE isDelete = 0 AND userID = %d AND isUpload = 0 AND cSuperID = 0 ORDER BY createTime DESC",TABLENAME, G_USER.u_id]] ;
        
        while ([rs next])
        {
            Article *arti = [[Article alloc] initArtWithClientID:[rs intForColumn:@"cID"]
                                            superClientArticleID:[rs intForColumn:@"cSuperID"]
                                                      createTime:[rs longLongIntForColumn:@"createTime"]
                                                     realpicPath:[rs stringForColumn:@"picPath"]
                                                         content:[rs stringForColumn:@"content"]
                                                           title:[rs stringForColumn:@"title"]
                                                        topicStr:[rs stringForColumn:@"topic"]
                             ] ;
            
            [resultList addObject:arti] ;
        }
        
        return resultList ;
    }
}

- (NSMutableArray *)getSubArticlesWithSuperArticleCLientID:(int)clientID
{
    @synchronized(DB)
    {
        if (!DB) [self creatDatabase];
        
        if (![DB open]) {
            NSLog(@"database open is failed");
            return nil;
        }
        
        [DB setShouldCacheStatements:YES];
        
        if(![DB tableExists:TABLENAME]) return nil;
        
        NSMutableArray *resultList = [[NSMutableArray alloc] initWithCapacity:1] ;
        
        FMResultSet *rs = [DB executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@ WHERE isDelete = 0 AND userID = %d AND isUpload = 0 AND cSuperID = %d",TABLENAME, G_USER.u_id,clientID]] ;
        
        while ([rs next])
        {
            Article *arti = [[Article alloc] initArtWithClientID:[rs intForColumn:@"cID"]
                                            superClientArticleID:[rs intForColumn:@"cSuperID"]
                                                      createTime:[rs longLongIntForColumn:@"createTime"]
                                                     realpicPath:[rs stringForColumn:@"picPath"]
                                                         content:[rs stringForColumn:@"content"]
                                                           title:[rs stringForColumn:@"title"]
                                                        topicStr:[rs stringForColumn:@"topic"]
                             ] ;
            
            [resultList addObject:arti] ;
        }
        
        return resultList ;
    }
}


- (Article *)getSuperArticleWithCLientID:(int)clientID
{
    @synchronized(DB)
    {
        if (!DB) [self creatDatabase];
        
        if (![DB open]) {
            NSLog(@"database open is failed");
            return nil;
        }
        
        [DB setShouldCacheStatements:YES];
        
        if(![DB tableExists:TABLENAME]) return nil;
        
        
        FMResultSet *rs = [DB executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@ WHERE isDelete = 0 AND userID = %d AND isUpload = 0 AND cID = %d",TABLENAME, G_USER.u_id,clientID]] ;
        
        while ([rs next])
        {
            Article *arti = [[Article alloc] initArtWithClientID:[rs intForColumn:@"cID"]
                                            superClientArticleID:[rs intForColumn:@"cSuperID"]
                                                      createTime:[rs longLongIntForColumn:@"createTime"]
                                                     realpicPath:[rs stringForColumn:@"picPath"]
                                                         content:[rs stringForColumn:@"content"]
                                                           title:[rs stringForColumn:@"title"]
                                                        topicStr:[rs stringForColumn:@"topic"]
                             ] ;
            return arti ;
        }
        return nil ;
    }
}


- (BOOL)ExistNotUploadArticle
{
    @synchronized(DB)
    {
        if (!DB) {
            [self creatDatabase];
        }
        
        if (![DB open]) {
            NSLog(@"database open is failed");
            return YES;
        }
        
        [DB setShouldCacheStatements:YES];
        
        if(![DB tableExists:TABLENAME])
        {
            return YES;
        }
        
        FMResultSet *rs = [DB executeQuery:[NSString stringWithFormat:@"SELECT COUNT(*) FROM %@ where isUploadFinished = 0 AND userID = %d", TABLENAME, G_USER.u_id]];
        
        int myCount = 0 ;
        
        while ([rs next])
        {
            myCount = [rs intForColumn:@"COUNT(*)"] ;
        }
        
        return (myCount > 0) ;
    }
}


- (BOOL)ExistThisArticle:(int)cid
{
    @synchronized(DB)
    {
        if (!DB) {
            [self creatDatabase];
        }
        
        if (![DB open]) {
            NSLog(@"database open is failed");
            return YES;
        }
        
        [DB setShouldCacheStatements:YES];
        
        if(![DB tableExists:TABLENAME])
        {
            return YES;
        }
        
        FMResultSet *rs = [DB executeQuery:[NSString stringWithFormat:@"SELECT COUNT(*) FROM %@ where cID = %d", TABLENAME, cid]];
        
        int myCount = 0 ;
        
        while ([rs next])
        {
            myCount = [rs intForColumn:@"COUNT(*)"] ;
        }
        
        return (myCount > 0) ;
    }
}


@end
