//
//  ReplyCell.h
//  SuBaoJiang
//
//  Created by apple on 15/6/3.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArticleComment.h"

@protocol ReplyCellDelegate <NSObject>
- (void)clickUserHead:(int)userID ;
@end

@interface ReplyCell : UITableViewCell
@property (nonatomic,weak) id <ReplyCellDelegate> delegate ;
@property (nonatomic,strong) ArticleComment *comment ;
+ (CGFloat)calculateHeightWithCmtStr:(NSString *)cmtStr ;
@end
