//
//  TopicHeader.h
//  SuBaoJiang
//
//  Created by apple on 15/6/12.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ArticleTopic ;
@class Acategory ;

@protocol TopicHeaderDelegate <NSObject>
- (void)seeMoreButtonClicked:(Acategory *)acate ;
@end

@interface TopicHeader : UIView
@property (nonatomic,strong) id <TopicHeaderDelegate> delegate ;
@property (nonatomic)        BOOL           isCateOrDefault ; // 话题分类, 或添加中
@property (nonatomic,strong) Acategory      *acate ;
@property (nonatomic,copy)   NSString       *title ;
@end
