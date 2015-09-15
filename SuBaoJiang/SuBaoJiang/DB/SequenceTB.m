//
//  SequenceTB.m
//  subao
//
//  Created by apple on 15/8/25.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "SequenceTB.h"

#define TABLENAME           @"SequenceTB"

#define SQL_CREATETABLE     [NSString stringWithFormat:@"CREATE TABLE %@ ( super_cid INT NOT NULL PRIMARY KEY DEFAULT '0' , sequence TEXT NOT NULL DEFAULT '' )",TABLENAME]

#define SQL_INSERTTABLE     [NSString stringWithFormat:@"INSERT INTO %@ ( super_cid , sequence ) VALUES (?,?)",TABLENAME]


static SequenceTB *instance ;

@implementation SequenceTB

+ (SequenceTB *)shareInstance
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
        FMResultSet *rs = [DB executeQuery:[NSString stringWithFormat:@"select max(super_cid) from %@",TABLENAME]];
        //判断结果集中是否有数据，如果有则取出数据
        while ([rs next]) {
            _maxID = [rs intForColumn:@"max(super_cid)"];
        }
        return _maxID ;
    }
}

- (BOOL)insertSequece:(NSString *)strOfList OfSuper_Cid:(int)cid
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
             [NSString stringWithFormat:@"%d",cid] ,
             strOfList
             ] ;
        
        return b ;
    }
    
    return false ;
}

- (BOOL)updateSequece:(NSString *)strOfList OfSuper_Cid:(int)cid
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
                        [NSString stringWithFormat:@"UPDATE %@ SET sequence = '%@' WHERE super_cid = %d ", TABLENAME , strOfList , cid]
                   ] ;
        
        return bResult ;
    }
    
    return false ;
}

- (NSString *)getSequeceStrWithCid:(int)cid
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
        
        FMResultSet *rs = [DB executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@ WHERE super_cid = %d " ,TABLENAME, cid]] ;
        NSString *strSequece = @"" ;
        while ([rs next])
        {
            strSequece = [rs stringForColumn:@"sequence"] ;
        }
        
        return strSequece ;
    }
}


- (BOOL)ExistThisSequece:(int)superCid
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
        
        if(![DB tableExists:TABLENAME]) {
            return YES;
        }
        
        FMResultSet *rs = [DB executeQuery:[NSString stringWithFormat:@"SELECT COUNT(*) FROM %@ where super_cid = %d ", TABLENAME, superCid]] ;
        
        int myCount = 0 ;
        
        while ([rs next]) {
            myCount = [rs intForColumn:@"COUNT(*)"] ;
        }
        
        return (myCount > 0) ;
    }
}

@end
