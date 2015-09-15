//
//  PasterManagement.m
//  subao
//
//  Created by apple on 15/9/14.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "PasterManagement.h"
#import "ServerRequest.h"

@implementation PasterManagement

+ (PasterManagement *)shareInstance
{
    static dispatch_once_t pred ;
    static PasterManagement *manager ;
    dispatch_once(&pred, ^{
        manager = [[PasterManagement alloc] init] ;
    }) ;
    
    return manager ;
}

- (NSArray *)allPastersList
{
    if (!_allPastersList)
    {
        _allPastersList = [[NSArray alloc] init] ;
        ResultParsered *result = [ServerRequest getAllPasters] ;
        NSArray *tempList = [result.info objectForKey:@"stickers"] ;
        NSMutableArray *resultList = [NSMutableArray array] ;
        for (NSDictionary *tempDic in tempList)
        {
            Paster *tempPaster = [[Paster alloc] initWithDic:tempDic] ;
            [resultList addObject:tempPaster] ;
        }
        _allPastersList = resultList ;
    }
    
    return _allPastersList ;
}


@end
