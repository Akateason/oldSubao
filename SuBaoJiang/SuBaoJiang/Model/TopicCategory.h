//
//  TopicCategory.h
//  SuBaoJiang
//
//  Created by TuTu on 15/7/29.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import <Foundation/Foundation.h>

//话题分类 . e.g.旅行,美食,买家秀

@interface TopicCategory : NSObject

@property (nonatomic)       NSInteger   ac_id       ; // 话题分类 '-1'-->所有分类 , '0'不能传
@property (nonatomic,copy)  NSString    *ac_content ; // 话题分类名称
@property (nonatomic,copy)  NSString    *ac_img     ; // 话题分类图片(暂时未用)

- (instancetype)initWithDic:(NSDictionary *)diction ;

@end
