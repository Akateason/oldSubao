//
//  PicUploadTB.m
//  SuBaoJiang
//
//  Created by apple on 15/7/27.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "PicUploadTB.h"
#import "PicWillUpload.h"


#define TABLENAME           @"PicUploadTB"
#define SQL_CREATETABLE     [NSString stringWithFormat:@"CREATE TABLE %@ ( id_PicWillUpload INT NOT NULL PRIMARY KEY DEFAULT '0', nameInFolder Nvarchar(128) NOT NULL DEFAULT '', isUploadFinished INT DEFAULT'0' NOT NULL , userID INT NOT NULL DEFAULT '0' , tick BIGINT DEFAULT '0' NOT NULL )",TABLENAME]
#define SQL_INSERTTABLE     [NSString stringWithFormat:@"INSERT INTO %@ ( id_PicWillUpload, nameInFolder , isUploadFinished , userID , tick  ) VALUES (?,?,?,?,?)",TABLENAME]

static PicUploadTB *instance ;

@implementation PicUploadTB

+ (PicUploadTB *)shareInstance
{
    if (!instance) {
        instance = [[[self class] alloc] init];
    }
    
    return instance;
}

- (NSString *)databaseFilePath
{
    NSArray *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [filePath firstObject];
    NSString *dbFilePath = [documentPath stringByAppendingPathComponent:SQLITEPATH];
    
    return dbFilePath;
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
    @synchronized(DB){
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
        FMResultSet *rs = [DB executeQuery:[NSString stringWithFormat:@"select max(id_PicWillUpload) from %@",TABLENAME]];
        //判断结果集中是否有数据，如果有则取出数据
        while ([rs next]) {
            _maxID = [rs intForColumn:@"max(id_PicWillUpload)"];
        }
        return _maxID ;
    }
}


- (BOOL)insertPicWillUpload:(PicWillUpload *)picture
{
    @synchronized(DB)
    {
        BOOL b = false ;
        if (!DB) [self creatDatabase];
        if (![DB open]) {
            NSLog(@"database open is failed");
            return false;
        }
        
        [DB setShouldCacheStatements:YES];
        
        if(![DB tableExists:TABLENAME]) [self creatTable];
        
        b = [DB executeUpdate:SQL_INSERTTABLE,
                [NSString stringWithFormat:@"%d",picture.id_PicWillUpload] ,
                picture.nameInFolder ,
                [NSString stringWithFormat:@"%d",picture.isUploadFinished] ,
                [NSString stringWithFormat:@"%d",G_USER.u_id] ,
                [NSString stringWithFormat:@"%lld",picture.tick]
            ];
        
        return b ;
    }
    
    return false ;
}


- (NSMutableArray *)getAllNotUploadedPictures
{
    @synchronized(DB)
    {
        if (!DB) {
            [self creatDatabase];
        }
        
        if (![DB open]) {
            NSLog(@"database open is failed");
            return nil;
        }
        
        [DB setShouldCacheStatements:YES];
        
        if(![DB tableExists:TABLENAME])
        {
            return nil;
        }
        
        NSMutableArray *resultList = [[NSMutableArray alloc] initWithCapacity:1] ;
        
        FMResultSet *rs = [DB executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@ WHERE isUploadFinished = 0 AND userID = %d",TABLENAME, G_USER.u_id]] ;
        
        while ([rs next])
        {
            PicWillUpload *pic = [[PicWillUpload alloc]
                                  initWithName:[rs stringForColumn:@"nameInFolder"]
                                uploadFinished:[rs intForColumn:@"isUploadFinished"]
                                         idPic:[rs intForColumn:@"id_PicWillUpload"]
                                        userID:[rs intForColumn:@"userID"]
                                          tick:[rs longLongIntForColumn:@"tick"]] ;
           
            [resultList addObject:pic] ;
        }
        
        return resultList ;
    }
}

- (NSMutableArray *)getAllUploaded
{
    @synchronized(DB)
    {
        if (!DB) {
            [self creatDatabase];
        }
        
        if (![DB open]) {
            NSLog(@"database open is failed");
            return nil;
        }
        
        [DB setShouldCacheStatements:YES];
        
        if(![DB tableExists:TABLENAME])
        {
            return nil;
        }
        
        NSMutableArray *resultList = [[NSMutableArray alloc] initWithCapacity:1] ;
        
        FMResultSet *rs = [DB executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@ WHERE userID = %d AND isUploadFinished = 1" ,TABLENAME, G_USER.u_id]] ;
        
        while ([rs next])
        {
            PicWillUpload *pic = [[PicWillUpload alloc]
                                  initWithName:[rs stringForColumn:@"nameInFolder"]
                                  uploadFinished:[rs intForColumn:@"isUploadFinished"]
                                  idPic:[rs intForColumn:@"id_PicWillUpload"]
                                  userID:[rs intForColumn:@"userID"]
                                  tick:[rs longLongIntForColumn:@"tick"]] ;
            
            [resultList addObject:pic] ;
        }
        
        return resultList ;
    }
}


- (BOOL)ExistNotUploadPicture
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

- (BOOL)uploadFinishedPictureWithPictureID:(int)picID
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
                    [NSString stringWithFormat:@"UPDATE %@ SET isUploadFinished = 1 WHERE    id_PicWillUpload = %d", TABLENAME , picID]
                   ];
        
        return bResult ;
    }
    
    return false ;
}

@end
