//
//  ArticlePraise.h
//  SuBaoJiang
//
//  Created by apple on 15/6/8.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import <Foundation/Foundation.h>
@class User ;
@interface ArticlePraise : NSObject

@property (nonatomic)               int         ao_id ; // 点赞id
@property (nonatomic,strong)        User        *user ;

// addition
@property (nonatomic,copy)          NSString    *img ;
@property (nonatomic)               int         a_id ;
@property (nonatomic)               long long   p_createTime ;
@property (nonatomic)               int         author_id ;

- (instancetype)initWithDict:(NSDictionary *)dict ;
- (instancetype)initByOwner ;
+ (NSArray *)getPraiseListWithDictList:(NSArray *)tempPraiseList ;

@end
