//
//  KSBarrageItemView.h
//  KwSing
//
//  Created by yuchenghai on 14/12/24.
//  Copyright (c) 2014年 kuwo.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArticleComment.h"

@interface KSBarrageItemView : UIView

@property (nonatomic, copy)   NSString  *strWillShow ;
@property (assign, nonatomic) NSInteger itemIndex;

- (void)setFlywordWithComment:(ArticleComment *)comment ;
- (void)setFlywordWithComment:(ArticleComment *)comment
                   WithBorder:(BOOL)hasBorder ;

//- (void)setAvatarWithImage:(UIImage *)image withContent:(NSString *)content;
//- (void)setAvatarWithImageString:(NSString *)imageStr withContent:(NSString *)content;

@end
