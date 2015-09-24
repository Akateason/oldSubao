//
//  SEcontainerCell.h
//  SuBaoJiang
//
//  Created by TuTu on 15/7/29.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ArticleTopic ;

@protocol SEcontainerCellDelegate <NSObject>
- (void)clickTopicInTheContainer:(ArticleTopic *)topic ;
@end

@interface SEcontainerCell : UITableViewCell
@property (nonatomic,weak) id <SEcontainerCellDelegate> delegate ;
@property (nonatomic,copy) NSMutableArray *topicList ;
+ (CGFloat)calculateHeightWithTopicList:(NSArray *)list ;
@end
