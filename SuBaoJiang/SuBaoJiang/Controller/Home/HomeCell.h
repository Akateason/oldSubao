//
//  HomeCell.h
//  SuBaoJiang
//
//  Created by apple on 15/6/2.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Article.h"
@class WPHotspotLabel ;
@class ArticleTopic ;

@protocol HomeCellDelegate <NSObject>

- (void)goToLogin ;
- (void)topicSelected:(ArticleTopic *)topic ;
- (void)articleHasPraised:(BOOL)hasPraised articleID:(int)articleID ;

@end

@interface HomeCell : UITableViewCell

@property (nonatomic,weak) id <HomeCellDelegate> delegate ;
@property (nonatomic,strong) Article    *article ;
@property (nonatomic)        BOOL       isflywordShow ; // 弹幕开关 . 通过ctrller控制

+ (CGFloat)calculateHomeCellHeight:(NSString *)content ;

@end
