//
//  Acategory.h
//  SuBaoJiang
//
//  Created by apple on 15/6/12.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ArticleTopic ;

// Topic Category

@interface Acategory : NSObject

@property (nonatomic)           int             ac_id ;
@property (nonatomic,copy)      NSString        *ac_content ;
@property (nonatomic,copy)      NSString        *ac_img ;
@property (nonatomic,copy)      NSString        *ac_color ;

@property (nonatomic,copy)      NSArray         *topicList ;

- (instancetype)initWithDic:(NSDictionary *)dict ;

+ (UIColor *)getCateColorWithCateID:(int)cateID ;
+ (UIColor *)getCateColorWithCateString:(NSString *)acContent ;

@end
