//
//  DtSuperCell.h
//  subao
//
//  Created by apple on 15/8/12.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Article ;

@protocol DtSuperCellDelegate <NSObject>
- (void)selectedTheImageWithAritcleID:(int)a_id ;
- (void)longPressedCallback:(Article *)article ;
@end

@interface DtSuperCell : UITableViewCell
@property (nonatomic,weak) id <DtSuperCellDelegate> delegate ;
@property (nonatomic,strong) Article *article ;
@property (nonatomic,strong) NSArray *allCommentsList ;
@property (nonatomic,assign) BOOL    isflywordShow ; // 弹幕开关
- (void)startOrCloseFlyword:(BOOL)bSwitch ;
+ (CGFloat)calculateHeight:(Article *)article ;
@end
