//
//  DtSubCell.h
//  subao
//
//  Created by apple on 15/8/12.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTlineSpaceLabel.h"

@class Article ;

@protocol DtSubCellDelegate <NSObject>
- (void)selectedTheImageWithAritcleID:(int)a_id ;
- (void)imgDownloadFinished ;
- (void)longPressedCallback:(Article *)article ;
@end

@interface DtSubCell : UITableViewCell
@property (weak, nonatomic) IBOutlet XTlineSpaceLabel   *lb_subContent;
@property (nonatomic,retain) id <DtSubCellDelegate> delegate ;
@property (nonatomic,strong) Article *subArticle ;
@property (nonatomic)        BOOL    isflywordShow ; // 弹幕开关
- (void)startOrCloseFlyword:(BOOL)bSwitch ;
+ (CGFloat)calculateHeightWithArticle:(Article *)subArticle ;
@end
