//
//  TopicCateCell.h
//  SuBaoJiang
//
//  Created by TuTu on 15/7/30.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ArticleTopic ;

#define HeightForTopicCateCell  140.0

@protocol TopicCateCellDelegate <NSObject>
- (void)cateCellSelected:(ArticleTopic *)topic ;
@end

@interface TopicCateCell : UITableViewCell
@property (nonatomic,weak) id <TopicCateCellDelegate> delegate ;
@property (nonatomic,strong) NSArray *topicList ;
@end
