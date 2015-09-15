//
//  ArticleTopic.h
//  SuBaoJiang
//
//  Created by apple on 15/6/5.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SEMC_ShowType) {
    SEMC_ShowType_default = 1 ,     //不显示
    SEMC_ShowType_suExperience ,    //速体验
    SEMC_ShowType_hot               //热门
};

typedef NS_ENUM(NSInteger, t_cate_type) {
    t_cate_type_default = 0 ,       //普通话题
    t_cate_type_suExperience        //速体验
};

@interface ArticleTopic : NSObject

@property (nonatomic)       int             t_id ;
@property (nonatomic,copy)  NSString        *t_content ;

@property (nonatomic,copy)  NSString        *t_img          ;
@property (nonatomic)       BOOL            is_hot          ; // 是否热门话题
@property (nonatomic)       int             tr_count        ; // 话题关联数
@property (nonatomic)       t_cate_type     t_cate          ; // 0-->普通话题 , 1-->速体验
@property (nonatomic)       long long       t_createtime    ; // 创建时间
@property (nonatomic)       long long       t_begintime     ; // 开始时间
@property (nonatomic)       long long       t_endtime       ; // 结束时间
@property (nonatomic)       NSString        *t_detail       ; // 速体验,图

@property (nonatomic)       SEMC_ShowType   showSEMC_Type   ; //用户展示速体验的imgType

- (instancetype)initEmptyTopicWithContent:(NSString *)str ;
- (instancetype)initWithDict:(NSDictionary *)dict ;
+ (NSArray *)getTopicListWithDictList:(NSArray *)tempTopicList ;
- (UIImage *)getShowTypeImageWithSemcOrTopic:(BOOL)semcOrTopic ;
- (NSString *)getTopicDetailString ;
- (UIImage *)getTopicTimeImage ;

@end
